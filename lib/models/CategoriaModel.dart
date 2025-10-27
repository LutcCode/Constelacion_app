class CategoriaModel {
  final int id;
  final String categoria;

  CategoriaModel(
      this.id,
      this.categoria,
      );

  CategoriaModel.fromJson(Map<String, dynamic> json)
      :
        id= json['id'],
        categoria=json['categoria'] ?? '';
}