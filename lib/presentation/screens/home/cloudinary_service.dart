import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  static const String cloudName = 'debn6u09z';
  static const String uploadPreset = 'ml_default';

  static Future<String?> uploadImage(File image) async {
    final Dio dioClient = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await dioClient.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      }
      return null;
    } catch (e) {
      print('[Cloudinary] Error: $e');
      return null;
    }
  }
}
