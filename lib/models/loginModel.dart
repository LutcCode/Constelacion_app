class LoginResponse {
  final String acceso;
  final String token;
  final String error;
  final int idUsuario;
  final String nombre_lector;


  LoginResponse(this.acceso,
      this.token,
      this.error,
      this.idUsuario,
      this.nombre_lector);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : acceso = json['acceso'],
        error = json['error'],
        token = json['token'],
        idUsuario = json['idUsuario'],
        nombre_lector = json['nombreUsuario'];
}