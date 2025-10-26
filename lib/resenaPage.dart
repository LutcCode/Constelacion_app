import 'package:flutter/material.dart';

class resenaPage extends StatefulWidget {
  const resenaPage({super.key});

  @override
  State<resenaPage> createState() => _resenaPageState();
}

class _resenaPageState extends State<resenaPage> {
  // AJUSTE: Inicializamos la URL como una cadena vacía.
  String _imageUrl = '';
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _imageUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Nombre Libro',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LADO IZQUIERDO: AHORA CONTIENE LA IMAGEN Y EL CAMPO DE TEXTO ---
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            image: _imageUrl.isNotEmpty && Uri.parse(_imageUrl).isAbsolute
                                ? DecorationImage(
                              image: NetworkImage(_imageUrl),
                              // AJUSTE CLAVE: Cambia cover por contain
                              fit: BoxFit.contain, // <-- ESTE ES EL CAMBIO
                              onError: (exception, stackTrace) {
                                // ...
                              },
                            )
                                : null,
                          ),
                          child: _imageUrl.isEmpty || !Uri.parse(_imageUrl).isAbsolute
                              ? Icon(Icons.image_outlined, color: Colors.grey[600], size: 50)
                              : null,
                        ),

                        const SizedBox(height: 12),
                        TextField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            labelText: 'URL de la Imagen',
                            hintText: 'Pega la URL aquí',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onChanged: (newUrl) {
                            setState(() {
                              _imageUrl = newUrl;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildTextField(label: 'Campo 1'),
                        const SizedBox(height: 12),
                        _buildTextField(label: 'Campo 2'),
                        const SizedBox(height: 12),
                        _buildTextField(label: 'Campo 3'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Otra Sección',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _buildTextField(label: 'Caja de Texto A', maxLines: 3),
                  const SizedBox(height: 12),
                  _buildTextField(label: 'Caja de Texto B'),
                  const SizedBox(height: 12),
                  _buildTextField(label: 'Caja de Texto C'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
