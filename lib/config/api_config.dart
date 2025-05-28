import '../utils/constants.dart';

class ApiConfig {
  static String baseURL = baseUrl;  // pakai baseURL beda dengan baseUrl dari constants
  static String apiKEY = apiKey;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKEY',
      };
}
