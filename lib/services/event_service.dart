import 'package:dio/dio.dart';
import 'package:animacare_front/constants/api_config.dart';
import 'package:animacare_front/models/evento.dart';

class EventService {
  final Dio _dio = Dio();
  final String _baseUrl = ApiConfig.baseUrl;

  // Crear evento
  Future<void> crearEvento(Evento evento) async {
    try {
      final data = {
        'titulo': evento.titulo,
        'categoria_id': evento.categoriaId,
        'mascota_id': evento.mascotaId,
        'veterinario_id': evento.veterinarioId,
        'fecha': evento.fecha.toIso8601String(),
        'hora': evento.hora.toIso8601String(),
        'descripcion': evento.descripcion ?? '',
      };
      print(data);
      print('************************************************************************************************************');
      final response = await _dio.post(
        '$_baseUrl/v1/event/create',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // ✅ Imprimir respuesta del backend
      print('✅ Evento creado: ${response.data}');
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al crear evento';
      print('❌ Error al crear evento: $error');
      throw Exception(error);
    }
  }

  // Actualizar solo la fecha y hora del evento
  Future<void> actualizarFechaEvento(int eventoId, DateTime fecha, DateTime hora) async {
    try {
      final data = {
        'fecha': fecha.toIso8601String(),
        'hora': hora.toIso8601String(),
      };

      await _dio.post(
        '$_baseUrl/v1/event/updateDate/$eventoId',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al actualizar fecha del evento';
      throw Exception(error);
    }
  }

  // Eliminar evento por ID
  Future<void> eliminarEvento(int eventoId) async {
    try {
      await _dio.post(
        '$_baseUrl/v1/event/delete/$eventoId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 'Error al eliminar evento';
      throw Exception(error);
    }
  }
  
}
