import 'package:dio/dio.dart';
import 'package:movie_finder/core/constants/api_constants.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    try {
      params ??= {};
      params["api_key"] = ApiConstants.apiKey;
      final response = await _dio.get(
        path,
        queryParameters: params,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception("API Hatası: $e");
    }
  }
}
