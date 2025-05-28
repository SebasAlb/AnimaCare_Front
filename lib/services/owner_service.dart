import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/constants/api_config.dart';

class OwnerService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConfig.baseUrl;

  Future<Dueno?> actualizarDueno(Dueno dueno) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/owner/update/${dueno.id}',
        data: dueno.toJsonWithoutPassword(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final parsed = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return Dueno.fromJson(parsed);
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }
}
