class LibroModel {
  final int id;
  final int id_resena;
  final int id_lector;
  final String nombre_libro;
  final String autor;
  final String no_paginas;
  final String fecha_publicacion;
  final String imagen;
  final String personaje_favorito;
  final String personaje_odiado;
  final String genero;
  final String tipoLibro;
  final String modoLectura;
  final String fraseFavorita;

  LibroModel({
    required this.id,
    required this.id_resena,
    required this.id_lector,
    required this.nombre_libro,
    required this.autor,
    required this.no_paginas,
    required this.fecha_publicacion,
    required this.imagen,
    required this.personaje_favorito,
    required this.personaje_odiado,
    required this.genero,
    required this.tipoLibro,
    required this.modoLectura,
    required this.fraseFavorita,
  });

  LibroModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      id_resena = json['id_resena'] ?? 0,
      id_lector = json['id_lector'] ?? 0,
      nombre_libro = json['nombre_libro'] ?? '',
      autor = json['autor'] ?? '',
      no_paginas = json['no_paginas'],
      fecha_publicacion = json['fecha_publicacion'] ?? '',
      imagen = json['imagen'] ?? '',
      personaje_favorito = json['personaje_favorito'] ?? '',
      personaje_odiado = json['personaje_odiado'] ?? '',
      genero = json['genero'] ?? '',
      tipoLibro = json['tipo-libro'] ?? '',
      modoLectura = json['modo-lectura'] ?? '',
      fraseFavorita = json['frase_favorita'] ?? '';
}
