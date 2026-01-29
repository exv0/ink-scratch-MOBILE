import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  Future<void> uploadImage(String imagePath) async {
    await dio.post('upload/url', data: {'image': imagePath});
  }
}
