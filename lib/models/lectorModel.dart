class LectorModel {
  final int id;
  final String name;
  final String app_lector;
  final String apm_lector;
  final int edad;
  final String fecha_nacimiento;
  final String email;
  final String password;


  LectorModel({
    required this.id,
    required this.name,
    required this.app_lector,
    required this.apm_lector,
    required this.edad,
    required this.fecha_nacimiento,
    required this.email,
    required this.password,
  });

  factory LectorModel.fromJson(Map<String, dynamic> json) {
    return LectorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      app_lector: json['app'] ?? '',
      apm_lector: json['apm'] ?? '',
      edad: json['edad'] ?? 0,
      fecha_nacimiento: json['direccion'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',

    );
  }
}
