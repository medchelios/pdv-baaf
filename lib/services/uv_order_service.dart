import 'api_service.dart';

class UVOrderService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> getStats() async {
    final response = await _apiService.get('uv-orders/stats');
    return response?['data'];
  }

  Future<List<Map<String, dynamic>>?> getRecentOrders({int limit = 10}) async {
    final response = await _apiService.get('uv-orders/recent?limit=$limit');
    if (response?['data'] != null) {
      return List<Map<String, dynamic>>.from(response!['data']);
    }
    return null;
  }


  Future<Map<String, dynamic>?> createOrder({
    required double amount,
    required String description,
    required String type, // 'order', 'transfer', 'credit_request'
  }) async {
    final response = await _apiService.post('uv-orders/create', {
      'amount': amount,
      'description': description,
      'type': type,
    });
    return response?['data'];
  }

  Future<bool> validateOrder({
    required int orderId,
    String? comment,
  }) async {
    final response = await _apiService.post('uv-orders/$orderId/validate', {
      'validator_comment': comment,
    });
    return response != null;
  }


  static const Map<String, String> orderTypes = {
    'order': 'Commande UV',
    'transfer': 'Transfert',
    'credit_request': 'Demande de crédit',
  };

  static const Map<String, String> orderStatuses = {
    'pending_validation': 'En attente',
    'validated': 'Validé',
    'rejected_by_validator': 'Refusé',
    'rejected_by_admin': 'Refusé BAAF',
  };
}
