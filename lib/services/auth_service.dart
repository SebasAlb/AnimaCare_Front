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
          'correo': correo, // CORRECTO
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
}
