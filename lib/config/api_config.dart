import '../utils/constants.dart';

class ApiConfig {
  static const String apiKey = '5f2e2075ea66445d83772eebff604c9e';
  static String baseURL = baseUrl;  // pakai baseURL beda dengan baseUrl dari constants
  static String apiKEY = apiKey;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKEY',
      };
}
