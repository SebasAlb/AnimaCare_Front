import 'package:dio/dio.dart';
import 'package:animacare_front/constants/api_config.dart';
import 'package:animacare_front/models/veterinario.dart';

class VeterinarianService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<Veterinario>> fetchVeterinarios() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v1/vet/getAll',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data as List;
      return data.map((json) => Veterinario.fromJson(json)).toList();
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al obtener veterinarios';
      throw Exception(error);
    }
  }
}
