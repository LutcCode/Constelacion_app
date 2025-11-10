class ResenaModel {
  final int id;
  final int id_libro;
  final String descripcion;
  final String resena;
  final String titulo;
  final String autor;
  final String imagen;



  ResenaModel({
    required this.id,
    required this.id_libro,
    required this.descripcion,
    required this.resena,
    required this.titulo,
    required this.autor,
    required this.imagen,
  });

  factory ResenaModel.fromJson(Map<String, dynamic> json) {
    return ResenaModel(
      id: json['id'] ?? 0,
      id_libro: json['id_libro'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      resena: json['resena'] ?? '',
      titulo: json['nombre_libro'] ?? '',
      autor: json['autor'] ?? '',
      imagen: json['imagen'] ?? '',
    );
  }
}
