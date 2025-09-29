import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import '../config/api_config.dart';

class UVOrderDataService {
  static final UVOrderDataService _instance = UVOrderDataService._internal();
  factory UVOrderDataService() => _instance;
  UVOrderDataService._internal();

  Map<String, dynamic>? _cachedData;
  DateTime? _cacheTimestamp;
  static const Duration _cacheValidity = Duration(minutes: 5);

  Future<Map<String, dynamic>> getUVData() async {
    // Vérifier le cache
    if (_cachedData != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheValidity) {
      return _cachedData!;
    }

    try {
      final token = AuthService().token;
      if (token == null) {
        throw Exception('Token d\'authentification manquant');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/mobile/agent/uv-orders/data'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _cachedData = Map<String, dynamic>.from(data['data']);
          _cacheTimestamp = DateTime.now();
          return _cachedData!;
        } else {
          throw Exception(
            data['message'] ?? 'Erreur lors de la récupération des données UV',
          );
        }
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      // En cas d'erreur, retourner des données par défaut
      return {
        'stats': {
          'total_orders': 0,
          'pending_orders': 0,
          'validated_orders': 0,
          'rejected_orders': 0,
        },
        'recent_orders': [],
        'available_actions': [
          {
            'type': 'refresh',
            'label': 'Actualiser',
            'icon': 'refresh',
            'color': 'gray',
          },
        ],
        'can_validate_orders': false,
      };
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    final data = await getUVData();
    return data['stats'] ?? {};
  }

  Future<List<Map<String, dynamic>>> getRecentOrders() async {
    final data = await getUVData();
    return List<Map<String, dynamic>>.from(data['recent_orders'] ?? []);
  }

  Future<List<Map<String, dynamic>>> getAvailableActions() async {
    final data = await getUVData();
    return List<Map<String, dynamic>>.from(data['available_actions'] ?? []);
  }

  Future<bool> canValidateOrders() async {
    final data = await getUVData();
    return data['can_validate_orders'] ?? false;
  }

  void clearCache() {
    _cachedData = null;
    _cacheTimestamp = null;
  }
}
