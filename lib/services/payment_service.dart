import 'api_service.dart';
import 'logger_service.dart';
import 'auth_service.dart';
import '../config/api_config.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>?> getRecentPayments({int limit = 5}) async {
    try {
      LoggerService.info('Récupération des paiements récents (limit: $limit)');
      
      final response = await _apiService.get('payments/recent?limit=$limit');
      
      if (response?['data'] != null && response?['data']?['payments'] != null) {
        final payments = List<Map<String, dynamic>>.from(response!['data']['payments']);
        LoggerService.info('${payments.length} paiements récents récupérés');
        return payments;
      } else {
        LoggerService.warning('Aucune donnée de paiements reçue');
        return null;
      }
    } catch (e) {
      LoggerService.error('Erreur lors de la récupération des paiements récents', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPaymentDetails(String paymentId) async {
    try {
      LoggerService.info('Récupération des détails du paiement: $paymentId');
      final response = await _apiService.get('payments/$paymentId');
      
      if (response?['data'] != null) {
        LoggerService.info('Détails du paiement récupérés');
        return response!['data']['payment'];
      } else {
        LoggerService.warning('Aucun détail de paiement reçu');
        return null;
      }
    } catch (e) {
      LoggerService.error('Erreur lors de la récupération des détails du paiement', e);
      return null;
    }
  }
}
