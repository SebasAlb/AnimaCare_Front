import 'package:animacare_front/models/detalles_mascota.dart';
import 'package:animacare_front/models/historial_medico.dart';
import 'package:dio/dio.dart';
import 'package:animacare_front/constants/api_config.dart';
import 'package:animacare_front/models/mascota.dart';

class PetService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConfig.baseUrl;

  // GET: Listar mascotas de un dueño
  Future<List<Mascota>> obtenerMascotasPorDueno(int duenioId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v1/pet/Owner/$duenioId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return (response.data as List)
          .map((e) => Mascota.fromJson(e))
          .toList();
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }

  // POST: Crear nueva mascota
  Future<Mascota> crearMascota(Mascota mascota, int duenioId) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/pet/create',
        data: {
          ...mascota.toJson(),
          'duenio_id': duenioId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return Mascota.fromJson(response.data);
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }

  // POST: Actualizar mascota
  Future<Mascota> actualizarMascota(Mascota mascota, int id) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/pet/update/$id',
        data: mascota.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return Mascota.fromJson(response.data);
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }

  // POST: Obtener historial médico por mascota y dueño
  Future<List<HistorialMedico>> obtenerHistorial(int mascotaId, int duenioId) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/v1/pet/history/Owner',
        data: {'mascota_id': mascotaId, 'duenio_id': duenioId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return (response.data as List)
          .map((e) => HistorialMedico.fromJson(e))
          .toList();
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error de red o del servidor';
      throw Exception(error);
    }
  }


  // GET: Obtener eventos, citas e historial de una mascota
  Future<DetallesMascota> obtenerDetallesMascota(int mascotaId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v1/pet/schedule/$mascotaId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return DetallesMascota.fromJson(response.data);
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al obtener detalles';
      throw Exception(error);
    }
  }

  Future<void> eliminarMascota(int id) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v1/pet/delete/$id',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Puedes imprimir si deseas verificar:
      print('✅ Mascota eliminada: ${response.data}');
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al eliminar mascota';
      print('❌ Error al eliminar mascota: $error');
      throw Exception(error);
    }
  }

}


