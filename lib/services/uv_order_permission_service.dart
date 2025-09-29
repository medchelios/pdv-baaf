import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import '../config/api_config.dart';

class UVOrderPermissionService {
  static final UVOrderPermissionService _instance =
      UVOrderPermissionService._internal();
  factory UVOrderPermissionService() => _instance;
  UVOrderPermissionService._internal();

  Map<String, bool>? _cachedPermissions;
  DateTime? _cacheTimestamp;
  static const Duration _cacheValidity = Duration(minutes: 5);

  Future<Map<String, bool>> getPermissions() async {
    // Vérifier le cache
    if (_cachedPermissions != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheValidity) {
      return _cachedPermissions!;
    }

    try {
      final token = AuthService().token;
      if (token == null) {
        throw Exception('Token d\'authentification manquant');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/mobile/agent/uv-orders/permissions',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _cachedPermissions = Map<String, bool>.from(data['data']);
          _cacheTimestamp = DateTime.now();
          return _cachedPermissions!;
        } else {
          throw Exception(
            data['message'] ?? 'Erreur lors de la récupération des permissions',
          );
        }
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      // En cas d'erreur, retourner des permissions par défaut (conservatrices)
        return {
          'can_create_orders': false, 
          'can_recharge_account': false,
          'can_validate_orders': false,
        };
    }
  }

  Future<bool> canCreateOrders() async {
    final permissions = await getPermissions();
    return permissions['can_create_orders'] ?? false;
  }

  Future<bool> canRechargeAccount() async {
    final permissions = await getPermissions();
    return permissions['can_recharge_account'] ?? false;
  }

  Future<bool> canValidateOrders() async {
    final permissions = await getPermissions();
    return permissions['can_validate_orders'] ?? false;
  }

  void clearCache() {
    _cachedPermissions = null;
    _cacheTimestamp = null;
  }
}
