import 'environment.dart';

class ApiConfig {
  static String get baseUrl => EnvironmentConfig.baseUrl;
  static const String apiVersion = 'api/mobile/agent';
  
  static String get fullApiUrl => '$baseUrl/$apiVersion';
  static String get authUrl => '$fullApiUrl/auth';
  static String get uvOrdersUrl => '$fullApiUrl/uv-orders';
  static String get paymentsUrl => '$fullApiUrl/payments';
  static String get statsUrl => '$fullApiUrl/stats';
  
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
