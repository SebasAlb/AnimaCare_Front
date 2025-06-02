import 'package:dio/dio.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/constants/api_config.dart';


class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConfig.baseUrl;

  Future<Dueno?> login(String correo, String contrasena) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/auth/login',
        data: {
          'correo': correo,
          'contrasena': contrasena,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final userJson = response.data['user'];
      return Dueno.fromJson(userJson);
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }

  Future<Dueno?> register({
    required String nombre,
    required String apellido,
    required String cedula,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/auth/register',
        data: {
          'nombre': nombre,
          'apellido': apellido,
          'cedula': cedula,
          'telefono': '',
          'correo': correo,
          'ciudad': '',
          'direccion': '',
          'contrasena': contrasena,
          'foto_url': null,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final userJson = response.data['user'];
      return Dueno.fromJson(userJson);
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }

  Future<String> changePassword({
    required int userId,
    required String contrasenaActual,
    required String nuevaContrasena,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/auth/changePassword/${userId}',
        data: {
          'contrasenaActual': contrasenaActual,
          'nuevaContrasena': nuevaContrasena,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data['message'];
    } on DioException catch (e) {
      final data = e.response?.data;
      final error = data is Map && data['error'] is String
          ? data['error']
          : 'Error al cambiar la contraseña';
      throw Exception(error);
    }
  }
}

