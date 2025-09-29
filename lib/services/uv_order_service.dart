import 'api_service.dart';
import 'logger_service.dart';

class UVOrderService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> getStats() async {
    LoggerService.info('Récupération des statistiques UV');
    final response = await _apiService.get('uv-orders/stats');
    if (response?['data'] != null) {
      LoggerService.info('Statistiques UV récupérées avec succès');
    } else {
      LoggerService.warning('Aucune donnée de statistiques UV');
    }
    return response?['data'];
  }

  Future<List<Map<String, dynamic>>?> getRecentOrders({int limit = 10}) async {
    LoggerService.info(
      'Récupération des commandes UV récentes (limit: $limit)',
    );
    final response = await _apiService.get('uv-orders/recent?limit=$limit');
    if (response?['data'] != null) {
      LoggerService.info('${response!['data'].length} commandes UV récupérées');
      return List<Map<String, dynamic>>.from(response['data']);
    }
    LoggerService.warning('Aucune commande UV récente');
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAvailableActions() async {
    LoggerService.info('Récupération des actions disponibles UV');
    final response = await _apiService.get('uv-orders/actions');
    if (response?['data'] != null) {
      LoggerService.info('${response!['data'].length} actions UV récupérées');
      return List<Map<String, dynamic>>.from(response['data']);
    }
    LoggerService.warning('Aucune action UV disponible');
    return null;
  }

  Future<Map<String, dynamic>?> createOrder({
    required double amount,
    required String description,
    required String type, // 'order', 'transfer', 'credit_request'
  }) async {
    LoggerService.info(
      'Création d\'une nouvelle commande UV: $amount GNF - $type',
    );
    final response = await _apiService.post('uv-orders/create', {
      'amount': amount,
      'description': description,
      'type': type,
    });
    if (response?['data'] != null) {
      LoggerService.info('Commande UV créée avec succès');
    } else {
      LoggerService.warning('Échec de création de la commande UV');
    }
    return response?['data'];
  }

  Future<bool> validateOrder({required int orderId, String? comment}) async {
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

  Future<Map<String, dynamic>?> getAccountBalance() async {
    LoggerService.info('Récupération du solde des comptes');
    final response = await _apiService.get('accounts/balance');
    LoggerService.debug('Response complète: $response');
    if (response?['data'] != null) {
      LoggerService.info('Solde des comptes récupéré avec succès');
    } else {
      LoggerService.warning(
        'Aucune donnée de solde disponible - Response: $response',
      );
    }
    return response?['data'];
  }

  Future<Map<String, dynamic>?> transferBetweenAccounts({
    required double amount,
    required String fromType,
    required String toType,
    String? description,
  }) async {
    LoggerService.info(
      'Transfert entre comptes: $amount de $fromType vers $toType',
    );
    final response = await _apiService.post('accounts/transfer', {
      'amount': amount,
      'from_type': fromType,
      'to_type': toType,
      'description': description,
    });
    if (response?['data'] != null) {
      LoggerService.info('Transfert effectué avec succès');
    } else {
      LoggerService.warning('Échec du transfert entre comptes');
    }
    return response?['data'];
  }
}
