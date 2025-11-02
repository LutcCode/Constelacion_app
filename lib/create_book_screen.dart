import 'package:flutter/material.dart';
import '../theme/app_strings.dart';
import '../widgets/rating_slider.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {

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

  // Clasificación (Sliders)
  double _romanceRating = 0.0;
  double _divertidoRating = 0.0;
  double _enojoRating = 0.0;
  double _tristezaRating = 0.0;
  double _fantasiaRating = 0.0;
  double _reflexionRating = 0.0;
  double _spicyRating = 0.0;
  double _tramaRating = 0.0;
  double _misterioRating = 0.0;
  double _finalRating = 0.0;

  // NUEVO: Inicializa el listener para actualizar la imagen
  @override
  void initState() {
    super.initState();
    // Escucha los cambios en el campo del link para redibujar la imagen
    _linkController.addListener(_updateLinkImage);
  }

  // NUEVO: Método para forzar el redibujo y mostrar la imagen
  void _updateLinkImage() {
    setState(() {});
  }

  @override
  void dispose() {
    // IMPORTANTE: Remueve el listener antes de liberar el controlador
    _linkController.removeListener(_updateLinkImage);

    _tituloController.dispose();
    _autorController.dispose();
    _paginasController.dispose();
    _personajeFavController.dispose();
    _personajeOdiadoController.dispose();
    _linkController.dispose();
    _fraseFavoritaController.dispose();
    super.dispose();
  }

  // Lógica de selección de fecha de publicación
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.miLectura),
        actions: [
          TextButton(
            onPressed: () {
              // Aqi irá la lógica de Laravel para guardar
              print('Datos a enviar:');
              print('Título: ${_tituloController.text}');
              print('Tipo de Historia: $_selectedStoryType');
              // ... Puedes imprimir todas las variables aquí para verificar ...
            },
            child: const Text(AppStrings.guardar, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna del titulo,autor,fecha
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
                // Columna de la Imagen
                _buildImageContainer(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna Izquierda (Páginas, Género, Personajes)
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
                // Columna Derecha (Tipos de Libros, Saga y Link)
                Expanded(
                  child: Column(
                    children: [
                      _buildBookTypeSelector(),
                      const SizedBox(height: 16),
                      _buildStoryTypeSelector(),
                      // El campo de link ha sido movido aquí
                      _buildTextField(_linkController, 'LINK DE LA IMAGEN'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- CLASIFICACIÓN (Sliders) ---
            const Text(AppStrings.clasificacion, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildRatingSliders(),
            const SizedBox(height: 24),

            // FRASE FAVORITA
            _buildFavoritePhraseField(),
          ],
        ),
      ),
    );
  }

  // WIDGETS AUXILIARES PARA LIMPIEZA DEL CÓDIGO

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

  // WIDGET MODIFICADO PARA MOSTRAR LA IMAGEN DESDE LA URL
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
                  'URL o Imagen inválida',
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

  // WIDGET PARA SELECCIONAR TIPO DE HISTORIA (SAGA/AUTOCONCLUSIVO)
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

  // Widget auxiliar para simplificar los botones de radio de Saga
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

  Widget _buildRatingSliders() {
    return Column(
      children: [
        RatingSlider(label: 'Romance', value: _romanceRating, onChanged: (v) => setState(() => _romanceRating = v)),
        RatingSlider(label: 'Divertido', value: _divertidoRating, onChanged: (v) => setState(() => _divertidoRating = v)),
        RatingSlider(label: 'Enojo', value: _enojoRating, onChanged: (v) => setState(() => _enojoRating = v)),
        RatingSlider(label: 'Tristeza', value: _tristezaRating, onChanged: (v) => setState(() => _tristezaRating = v)),
        RatingSlider(label: 'Fantasía', value: _fantasiaRating, onChanged: (v) => setState(() => _fantasiaRating = v)),
        RatingSlider(label: 'Reflexión', value: _reflexionRating, onChanged: (v) => setState(() => _reflexionRating = v)),
        RatingSlider(label: 'Spicy', value: _spicyRating, onChanged: (v) => setState(() => _spicyRating = v)),
        RatingSlider(label: 'Trama', value: _tramaRating, onChanged: (v) => setState(() => _tramaRating = v)),
        RatingSlider(label: 'Misterio', value: _misterioRating, onChanged: (v) => setState(() => _misterioRating = v)),
        RatingSlider(label: 'Final', value: _finalRating, onChanged: (v) => setState(() => _finalRating = v)),
      ],
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