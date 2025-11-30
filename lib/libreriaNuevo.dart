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
  // CLAVE: GlobalKey para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  String _selectedBookType = AppStrings.tipoLibroFisico; // Valor por defecto
  String _selectedStoryType = AppStrings.autoconclusivo; // Valor por defecto
  String? _selectedGenre;

  // Géneros (Simulación para un Dropdown)
  final List<String> _genres = [
    AppStrings.generoTerror,
    AppStrings.generoAmor,
    AppStrings.generoFantasia,
    AppStrings.generoMisterio,
  ];

  // Lista de modos de lectura válidos (para validación)
  final List<String> _storyModes = [
    AppStrings.autoconclusivo, AppStrings.saga, AppStrings.bilogia, AppStrings.trilogia
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
        Uri.parse('${Ambiente.urlServer}/api/libro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{'id': idLibro}),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final data = responseJson.isNotEmpty ? responseJson[0] : null;

        if (data != null) {
          final libro = LibroModel.fromJson(data);

          // --- LÓGICA DE CORRECCIÓN DE RADIOS Y DROPDOWN ---

          // Género (Dropdown): Usar valor cargado o primer valor si no existe en lista local
          String loadedGenre = libro.genero ?? _genres.first;
          if (!_genres.contains(loadedGenre)) {
            loadedGenre = _genres.first;
          }

          // Tipo de Libro (Radio 1): Cargar solo si es un valor conocido
          String loadedBookType = libro.tipoLibro ?? AppStrings.tipoLibroFisico;

          // Modo de Lectura (Radio 2): Cargar solo si es un valor conocido
          String loadedStoryType = libro.modoLectura ?? AppStrings.autoconclusivo;


          setState(() {
            // Rellenar controladores
            _tituloController.text = libro.nombre_libro ?? '';
            _autorController.text = libro.autor ?? '';
            _paginasController.text = libro.no_paginas ?? '';
            _personajeFavController.text = libro.personaje_favorito ?? '';
            _personajeOdiadoController.text = libro.personaje_odiado ?? '';
            _linkController.text = libro.imagen ?? '';
            _fraseFavoritaController.text = libro.fraseFavorita ?? '';

            // Rellenar selectores
            _selectedGenre = loadedGenre;

            // CORRECCIÓN PARA RADIOS: Solo actualiza si el valor de la DB coincide con una opción local.
            if (loadedBookType == AppStrings.tipoLibroFisico || loadedBookType == AppStrings.tipoLibroDigital) {
              _selectedBookType = loadedBookType;
            } else {
              _selectedBookType = AppStrings.tipoLibroFisico; // Valor por defecto seguro
            }

            if (_storyModes.contains(loadedStoryType)) {
              _selectedStoryType = loadedStoryType;
            } else {
              _selectedStoryType = AppStrings.autoconclusivo; // Valor por defecto seguro
            }

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
    // CLAVE: 1. Validar campos de texto (TextFormField)
    if (!_formKey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Faltan Campos',
        text: 'Por favor, rellena todos los campos obligatorios del formulario.',
      );
      return;
    }

    // 2. Validar Dropdown y Fecha (no validados por FormKey)
    if (_selectedGenre == null || _fechaPublicacion == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error de Formulario',
        text: 'Por favor, selecciona el género y la fecha de publicación.',
      );
      return;
    }


    // Determinar si es nueva creación (id=0) o edición (id=widget.idLibro)
    final int bookId = widget.idLibro ?? 0;

    // Determinar el endpoint: /libro/new (si id=0) o /libro/update (si id>0)
    final String apiUrl = bookId == 0
        ? '${Ambiente.urlServer}/api/libro/new'
        : '${Ambiente.urlServer}/api/libro/update';

    // 3. Crear el objeto Modelo con los datos del formulario
    final bookData = {
      'id': bookId,
      'id_lector': Ambiente.idUser,
      'nombre_libro': _tituloController.text,
      'autor': _autorController.text,
      'no_paginas': _paginasController.text.isNotEmpty ? _paginasController.text : '0',
      'genero': _selectedGenre!,
      'tipo_libro': _selectedBookType,
      'modo_lectura': _selectedStoryType,
      'fecha_publicacion': _fechaPublicacion!.toIso8601String().split('T')[0],
      'imagen': _linkController.text,
      'personaje_favorito': _personajeFavController.text,
      'personaje_odiado': _personajeOdiadoController.text,
      'frase_favorita': _fraseFavoritaController.text,
    };


    // 4. Petición HTTP POST a Laravel
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );

      // 5. Manejar la respuesta
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
        // Fallo del servidor (Error 500/422)
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error del Servidor',
          text: 'Fallo al guardar el libro. Código: ${response.statusCode}. Revisa el log.',
        );
        print('JSON ENVIADO: ${jsonEncode(bookData)}');
        print('Respuesta de Laravel: ${response.body}');
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error de Conexión',
        text: 'No se pudo conectar al servidor. ($e)',
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
        // CLAVE: Envuelve el contenido en un Form
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // Usamos TextFormField con validación obligatoria
                        _buildValidatedTextField(_tituloController, AppStrings.titulo),
                        _buildValidatedTextField(_autorController, AppStrings.autor),
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
                        // Campo no obligatorio usa TextField
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
      ),
    );
  }

  // WIDGETS AUXILIARES MODIFICADOS

  // Nuevo widget para campos obligatorios (TextFormField con validador)
  Widget _buildValidatedTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField( // Usamos TextFormField
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio'; // Mensaje de error visible
          }
          return null;
        },
      ),
    );
  }

  // Widget para campos opcionales (TextField original)
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