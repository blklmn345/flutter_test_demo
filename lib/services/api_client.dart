import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio();
  }

  ApiClient.mock(
    Dio dio,
  ) {
    _dio = dio;
  }

  static ApiClient get instance => ApiClient._();

  Future<Response<String>> get(String url) async {
    return await _dio.get(url);
  }
}
