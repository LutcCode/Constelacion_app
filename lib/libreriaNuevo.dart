import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '../theme/app_strings.dart';
import 'package:constelacion/models/libroModel.dart';
import 'package:constelacion/libreriaPage.dart';
import 'package:constelacion/models/ambiente.dart';

class libreriaNuevo extends StatefulWidget {
  // Acepta un ID de libro opcional. Si es nulo, es nuevo.
  final int? idLibro;

  const libreriaNuevo({super.key, this.idLibro});

  @override
  State<libreriaNuevo> createState() => _libreriaNuevoState();
}

class _libreriaNuevoState extends State<libreriaNuevo> {
  // Estado de carga para la edición
  bool _isFetching = false;

  // Controles de texto
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _paginasController = TextEditingController();
  final TextEditingController _personajeFavController = TextEditingController();
  final TextEditingController _personajeOdiadoController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _fraseFavoritaController = TextEditingController();

  // Opciones de Selección
  String _selectedBookType = AppStrings.tipoLibroFisico;
  String _selectedStoryType = AppStrings.autoconclusivo;
  String? _selectedGenre;

  // Géneros (Simulación para un Dropdown)
  final List<String> _genres = [
    AppStrings.generoTerror,
    AppStrings.generoAmor,
    AppStrings.generoFantasia,
    AppStrings.generoMisterio,
  ];

  // Fecha
  DateTime? _fechaPublicacion;

  @override
  void initState() {
    super.initState();
    _linkController.addListener(_updateLinkImage);
    _selectedGenre = _genres.first;

    // Si se pasa un ID, estamos editando -> Cargar datos
    if (widget.idLibro != null) {
      _fetchBookDetails(widget.idLibro!);
    }
  }

  void _updateLinkImage() {
    setState(() {});
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _paginasController.dispose();
    _personajeFavController.dispose();
    _personajeOdiadoController.dispose();
    _linkController.dispose();
    _fraseFavoritaController.dispose();
    _linkController.removeListener(_updateLinkImage);
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaPublicacion ?? DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaPublicacion) {
      setState(() {
        _fechaPublicacion = picked;
      });
    }
  }

  // -----------------------------------------------------------------
  // FUNCIÓN DE RECUPERACIÓN DE DATOS (LECTURA)
  // -----------------------------------------------------------------
  Future<void> _fetchBookDetails(int idLibro) async {
    setState(() {
      _isFetching = true;
    });

    try {
      final response = await http.post(
        // Endpoint que ya tienes definido en tu API: /api/libro
        Uri.parse('${Ambiente.urlServer}/api/libro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{'id': idLibro}),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        // Tu endpoint show devuelve una lista, tomamos el primer elemento
        final data = responseJson.isNotEmpty ? responseJson[0] : null;

        if (data != null) {
          // Asumiendo que LibroModel tiene un constructor fromJson compatible
          final libro = LibroModel.fromJson(data);

          // --- LÓGICA DE CORRECCIÓN DE DROPDOWN AÑADIDA ---
          String loadedGenre = libro.genero ?? _genres.first;

          // CRÍTICO: Si el valor cargado no está en nuestra lista de opciones (_genres),
          // usamos el primer elemento de la lista para evitar el error de aserción (zero items).
          if (!_genres.contains(loadedGenre)) {
            loadedGenre = _genres.first;
          }
          // --- FIN DE LÓGICA DE CORRECCIÓN ---

          setState(() {
            // Rellenar controladores
            _tituloController.text = libro.nombre_libro ?? '';
            _autorController.text = libro.autor ?? '';
            _paginasController.text = libro.no_paginas ?? '';
            _personajeFavController.text = libro.personaje_favorito ?? '';
            _personajeOdiadoController.text = libro.personaje_odiado ?? '';
            _linkController.text = libro.imagen ?? '';
            _fraseFavoritaController.text = libro.fraseFavorita ?? '';

            // Rellenar selectores usando el valor seguro
            _selectedGenre = loadedGenre; // <-- Usamos el valor verificado
            _selectedBookType = libro.tipoLibro ?? AppStrings.tipoLibroFisico;
            _selectedStoryType = libro.modoLectura ?? AppStrings.autoconclusivo;

            // Rellenar fecha
            if (libro.fecha_publicacion != null) {
              _fechaPublicacion = DateTime.parse(libro.fecha_publicacion!);
            }
          });
        } else {
          QuickAlert.show(context: context, type: QuickAlertType.warning, text: 'Libro no encontrado.');
        }
      } else {
        QuickAlert.show(context: context, type: QuickAlertType.error, title: 'Error de Lectura', text: 'No se pudo cargar el libro. Código: ${response.statusCode}');
      }
    } catch (e) {
      QuickAlert.show(context: context, type: QuickAlertType.error, title: 'Error de Conexión', text: 'Fallo al recuperar los datos del libro.');
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  // -----------------------------------------------------------------
  // FUNCIÓN DE GUARDADO (CREAR/ACTUALIZAR)
  // -----------------------------------------------------------------
  Future<void> _saveBook() async {
    // 1. Validaciones básicas
    if (_tituloController.text.isEmpty || _autorController.text.isEmpty || _selectedGenre == null || _fechaPublicacion == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error de Formulario',
        text: 'Por favor, completa el título, autor, género y fecha de publicación.',
      );
      return;
    }

    // Determinar si es nueva creación (id=0) o edición (id=widget.idLibro)
    final int bookId = widget.idLibro ?? 0;

    // Determinar el endpoint: /libro/new (si id=0) o /libro/update (si id>0)
    final String apiUrl = bookId == 0
        ? '${Ambiente.urlServer}/api/libro/new'
        : '${Ambiente.urlServer}/api/libro/update';

    // 2. Crear el objeto Modelo con los datos del formulario
    final bookData = {
      // Si estamos actualizando, enviamos el ID. Si es nuevo, enviamos 0.
      'id': bookId,
      'id_lector': Ambiente.idUser,
      'nombre_libro': _tituloController.text,
      'autor': _autorController.text,
      'no_paginas': _paginasController.text.isNotEmpty ? _paginasController.text : '0',
      'genero': _selectedGenre!,
      'tipo_libro': _selectedBookType, // Usamos el nombre de columna correcto: tipo_libro
      'modo_lectura': _selectedStoryType, // Usamos el nombre de columna correcto: modo_lectura
      'fecha_publicacion': _fechaPublicacion!.toIso8601String().split('T')[0],
      'imagen': _linkController.text,
      'personaje_favorito': _personajeFavController.text,
      'personaje_odiado': _personajeOdiadoController.text,
      'frase_favorita': _fraseFavoritaController.text, // Usamos el nombre de columna correcto: frase_favorita
    };


    // 3. Petición HTTP POST a Laravel
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );

      // 4. Manejar la respuesta
      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: bookId == 0 ? '¡Libro guardado correctamente!' : '¡Libro actualizado correctamente!',
          confirmBtnText: 'Continuar',
          onConfirmBtnTap: () {
            Navigator.pop(context); // Cierra la página de edición/creación
          },
        );
      }else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error del Servidor',
          text: 'Fallo al guardar el libro. Código: ${response.statusCode}.',
        );
        print('JSON ENVIADO: ${jsonEncode(bookData)}');
        print('Respuesta de Laravel: ${response.body}');
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error de Conexión',
        text: 'No se pudo conectar al servidor. Asegúrate de que Laravel esté corriendo. ($e)',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.idLibro != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editarLibro : AppStrings.miLectura), // Título dinámico
        actions: [
          TextButton(
            onPressed: _saveBook,
            child: const Text(AppStrings.guardar, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent)) // Muestra carga al buscar datos
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(_tituloController, AppStrings.titulo),
                      _buildTextField(_autorController, AppStrings.autor),
                      _buildDateButton(context),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildImageContainer(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(_paginasController, AppStrings.noPaginasa, keyboardType: TextInputType.number),
                      _buildGenreDropdown(),
                      _buildTextField(_personajeFavController, AppStrings.personajeFav),
                      _buildTextField(_personajeOdiadoController, AppStrings.personajeOdiado),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildBookTypeSelector(),
                      const SizedBox(height: 16),
                      _buildStoryTypeSelector(),
                      _buildTextField(_linkController, 'LINK DE LA IMAGEN'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(AppStrings.clasificacion, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            _buildFavoritePhraseField(),
          ],
        ),
      ),
    );
  }

  // WIDGETS AUXILIARES (sin cambios)

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
      ),
    );
  }

  Widget _buildDateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton(
        onPressed: () => _selectDate(context),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          _fechaPublicacion == null
              ? AppStrings.fechaPublicacion
              : 'Publicación: ${_fechaPublicacion!.day}/${_fechaPublicacion!.month}/${_fechaPublicacion!.year}',
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    final imageUrl = _linkController.text;

    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Portada (URL) no válida',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            );
          },
        ),
      )
          : const Center(
        child: Text('Portada (URL)'),
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: AppStrings.genero,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        value: _selectedGenre,
        items: _genres.map((String genre) {
          return DropdownMenuItem<String>(
            value: genre,
            child: Text(genre),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGenre = newValue;
          });
        },
      ),
    );
  }

  Widget _buildBookTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text(AppStrings.tipoLibroFisico),
          leading: Radio<String>(
            value: AppStrings.tipoLibroFisico,
            groupValue: _selectedBookType,
            onChanged: (String? value) {
              setState(() {
                _selectedBookType = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(AppStrings.tipoLibroDigital),
          leading: Radio<String>(
            value: AppStrings.tipoLibroDigital,
            groupValue: _selectedBookType,
            onChanged: (String? value) {
              setState(() {
                _selectedBookType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoryTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStoryRadio(AppStrings.autoconclusivo),
        _buildStoryRadio(AppStrings.saga),
        _buildStoryRadio(AppStrings.bilogia),
        _buildStoryRadio(AppStrings.trilogia),
      ],
    );
  }

  Widget _buildStoryRadio(String title) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      leading: Radio<String>(
        value: title,
        groupValue: _selectedStoryType,
        onChanged: (String? value) {
          setState(() {
            _selectedStoryType = value!;
          });
        },
      ),
    );
  }

  Widget _buildFavoritePhraseField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _fraseFavoritaController,
        maxLines: 5, // Cuadro de texto largo
        decoration: const InputDecoration(
          labelText: AppStrings.fraseFavorita,
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
      ),
    );
  }
}