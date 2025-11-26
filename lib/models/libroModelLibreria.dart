class LibroModelLibreria {

  final int id;
  final int id_resena;
  final int? id_editorial;
  final int? id_tipo_libro;
  final int? id_modo_lectura;

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

  LibroModelLibreria({

    required this.id,
    required this.id_resena,
    this.id_editorial,
    this.id_tipo_libro,
    this.id_modo_lectura,

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

  LibroModelLibreria.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_resena = json['id_resena'] ?? 0,
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
        personaje_odiado = json['personaje_odiado'] ?? '',
        genero = json['genero'] ?? '',
        tipoLibro = json['tipo-libro'] ?? '',
        modoLectura = json['modo-lectura'] ?? '',
        fraseFavorita = json['frase_favorita'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id_lector': id_lector,
      'nombre_libro': nombre_libro,
      'autor': autor,
      'no_paginas': no_paginas,
      'fecha_publicacion': fecha_publicacion,
      'imagen': imagen,
      'personaje_favorito': personaje_favorito,
      'personaje_odiado': personaje_odiado,
      'genero': genero,
      'tipo_libro': tipoLibro,
      'modo_lectura': modoLectura,
      'frase_favorita': fraseFavorita,
    };
  }
}