class ResenaModel {
  final int id;
  final String descripcion;
  final String resena;
  final String titulo;
  final String autor;
  final String imagen;



  ResenaModel({
    required this.id,
    required this.descripcion,
    required this.resena,
    required this.titulo,
    required this.autor,
    required this.imagen,
  });

  factory ResenaModel.fromJson(Map<String, dynamic> json) {
    return ResenaModel(
      id: json['id'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      resena: json['resena'] ?? '',
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      imagen: json['imagen'] ?? '',
    );
  }
}
