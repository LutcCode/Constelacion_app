class LectorModel {
  final int id;
  final String app_lector;
  final String apm_lector;
  final int edad;
  final String fecha_nacimiento;
  final String email;
  final String password;
  final String name;

  LectorModel({
    required this.id,
    required this.app_lector,
    required this.apm_lector,
    required this.edad,
    required this.fecha_nacimiento,
    required this.email,
    required this.password,
    required this.name,
  });

  factory LectorModel.fromJson(Map<String, dynamic> json) {
    return LectorModel(
      id: json['id'] ?? 0,
      app_lector: json['app'] ?? '',
      apm_lector: json['apm'] ?? '',
      edad: json['edad'] ?? 0,
      fecha_nacimiento: json['direccion'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
