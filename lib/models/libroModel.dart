class LibroModel {
  final int id;
  final int id_categoria;
  final int id_editorial;
  final int id_lector;
  final int id_tipo_libro;
  final int id_modo_lectura;
  final String nombre_libro;
  final String autor;
  final String no_paginas;
  final String fecha_publicacion;
  final String imagen;
  final String personaje_favorito;
  final String personaje_odiado;

  LibroModel({
    required this.id,
    required this.id_categoria,
    required this.id_editorial,
    required this.id_lector,
    required this.id_tipo_libro,
    required this.id_modo_lectura,
    required this.nombre_libro,
    required this.autor,
    required this.no_paginas,
    required this.fecha_publicacion,
    required this.imagen,
    required this.personaje_favorito,
    required this.personaje_odiado,
  });

  LibroModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_categoria = json['id_categoria'],
        id_editorial = json['id_editorial'],
        id_lector = json['id_lector'],
        id_tipo_libro = json['id_tipo_libro'],
        id_modo_lectura = json['id_modo_lectura'],
        nombre_libro = json['nombre_libro'] ?? '',
        autor = json['autor'] ?? '',
        no_paginas = json['no_paginas'],
        fecha_publicacion = json['fecha_publicacion'] ?? '',
        imagen = json['imagen'] ?? '',
        personaje_favorito = json['personaje_favorito'] ?? '',
        personaje_odiado = json['personaje_odiado'] ?? '';
}
