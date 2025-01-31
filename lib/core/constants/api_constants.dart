import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
  static final String apiKey = dotenv.env['API_KEY'] ?? "";
  static final String imageBaseUrl = dotenv.env['IMAGE_BASE_URL'] ?? "";
}
