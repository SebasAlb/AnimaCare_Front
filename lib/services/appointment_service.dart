import 'package:animacare_front/constants/api_config.dart';
import 'package:animacare_front/models/cita.dart';
import 'package:dio/dio.dart';

class AppointmentService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConfig.baseUrl;

  /// POST: Crear una nueva cita
  Future<void> crearCita(Cita cita) async {
    try {
      await _dio.post(
        '$_baseUrl/v1/appointment/create',
        data: cita.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al crear cita';
      throw Exception(error);
    }
  }

  /// POST: Actualizar una cita existente
  Future<void> actualizarCita(int id, Cita cita) async {
    try {
      await _dio.post(
        '$_baseUrl/v1/appointment/update/$id',
        data: cita.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al actualizar cita';
      throw Exception(error);
    }
  }

  /// POST: Eliminar una cita por su ID
  Future<void> eliminarCita(int id) async {
    try {
      await _dio.post(
        '$_baseUrl/v1/appointment/delete/$id',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al eliminar cita';
      throw Exception(error);
    }
  }
}
