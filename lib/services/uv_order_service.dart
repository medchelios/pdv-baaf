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

  Future<bool> validateOrder({required int orderId, String? comment}) async {
    final response = await _apiService.post('uv-orders/$orderId/validate', {
      'validator_comment': comment,
    });
    return response != null;
  }

  Future<bool> rejectOrder({
    required int orderId,
    required String comment,
  }) async {
    final response = await _apiService.post('uv-orders/$orderId/reject', {
      'reject_comment': comment,
    });
    return response != null;
  }

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

  Future<List<Map<String, dynamic>>?> getNetworkMembers() async {
    LoggerService.info('Récupération des membres du réseau');
    final response = await _apiService.get('uv-orders/network-members');
    if (response?['data'] != null) {
      LoggerService.info(
        '${response!['data'].length} membres du réseau récupérés',
      );
      return List<Map<String, dynamic>>.from(response['data']);
    }
    LoggerService.warning('Aucun membre du réseau');
    return null;
  }

  Future<Map<String, dynamic>?> getTransactionBalance() async {
    LoggerService.info('Récupération du solde transactionnel');
    final response = await _apiService.get('uv-orders/transaction-balance');
    if (response?['data'] != null) {
      LoggerService.info('Solde transactionnel récupéré avec succès');
    } else {
      LoggerService.warning('Aucun solde transactionnel disponible');
    }
    return response?['data'];
  }

  Future<Map<String, dynamic>?> getPermissions() async {
    LoggerService.info('Récupération des permissions UV');
    final response = await _apiService.get('uv-orders/permissions');
    if (response?['data'] != null) {
      LoggerService.info('Permissions UV récupérées avec succès');
    } else {
      LoggerService.warning('Aucune permission UV disponible');
    }
    return response?['data'];
  }

  Future<Map<String, dynamic>?> createOrder({
    required double amount,
    required String description,
  }) async {
    LoggerService.info('Création d\'une nouvelle commande UV: $amount GNF');
    final response = await _apiService.post('uv-orders/create', {
      'amount': amount,
      'description': description,
    });
    if (response?['data'] != null) {
      LoggerService.info('Commande UV créée avec succès');
    } else {
      LoggerService.warning('Échec de création de la commande UV');
    }
    return response?['data'];
  }

  Future<Map<String, dynamic>?> createRechargeRequest({
    required double amount,
    required String description,
  }) async {
    LoggerService.info('Création d\'une demande de recharge: $amount GNF');
    final response = await _apiService.post('uv-orders/recharge', {
      'amount': amount,
      'description': description,
    });
    if (response?['data'] != null) {
      LoggerService.info('Demande de recharge créée avec succès');
    } else {
      LoggerService.warning('Échec de création de la demande de recharge');
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
