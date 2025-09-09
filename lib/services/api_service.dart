import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';
import 'logger_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Map<String, String> get _headers {
    final token = AuthService().token;
    return token != null 
      ? ApiConfig.getAuthHeaders(token)
      : ApiConfig.defaultHeaders;
  }
  Future<Map<String, dynamic>?> get(String endpoint) async {
    try {
      LoggerService.debug('GET $endpoint');
      final response = await http.get(
        Uri.parse('${ApiConfig.fullApiUrl}/$endpoint'),
        headers: _headers,
      );

      LoggerService.debug('GET Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        LoggerService.warning('GET Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      LoggerService.error('GET Exception: $endpoint', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> post(String endpoint, Map<String, dynamic> data) async {
    try {
      LoggerService.debug('POST $endpoint with data: $data');
      final response = await http.post(
        Uri.parse('${ApiConfig.fullApiUrl}/$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );

      LoggerService.debug('POST Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        LoggerService.warning('POST Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      LoggerService.error('POST Exception: $endpoint', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.fullApiUrl}/$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );


      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.fullApiUrl}/$endpoint'),
        headers: _headers,
      );


      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}