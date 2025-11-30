class LectorModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String app_lector;
  final String apm_lector;
  final String usuario;
  final int edad;
  final String fecha_nacimiento;
  final bool suscripcion;

  LectorModel({
    required this.id,
    required this.name,
    required this.app_lector,
    required this.apm_lector,
    required this.usuario,
    required this.edad,
    required this.fecha_nacimiento,
    required this.email,
    required this.password,
    required this.suscripcion,
  });

  LectorModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      name = json['name'] ?? '',
      email = json['email'] ?? '',
      password = json['password'] ?? '',
      app_lector = json['app_lector'] ?? '',
      apm_lector = json['apm_lector'] ?? '',
      usuario = json['usuario'] ?? '',
      edad = json['edad'] ?? 0,
      fecha_nacimiento = json['direccion'] ?? '',
      suscripcion = json['suscripcion'] ?? '';
}
