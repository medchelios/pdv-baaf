import 'api_service.dart';
import 'logger_service.dart';

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
        final payments = List<Map<String, dynamic>>.from(
          response!['data']['payments'],
        );
        LoggerService.info('${payments.length} paiements récents récupérés');
        return payments;
      } else {
        LoggerService.warning('Aucune donnée de paiements reçue');
        return null;
      }
    } catch (e) {
      LoggerService.error(
        'Erreur lors de la récupération des paiements récents',
        e,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPayments({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      LoggerService.info(
        'Récupération des paiements (page: $page, limit: $limit)',
      );

      final String url = 'payments?page=$page&limit=$limit';

      final response = await _apiService.get(url);

      if (response?['data'] != null) {
        LoggerService.info('Paiements récupérés avec succès');
        final data = response!['data'] as Map<String, dynamic>;
        final summary = data['summary'];
        if (summary != null) {
          LoggerService.info(
            'Summary API -> total_payments: ${summary['total_payments']}, completed: ${summary['completed_payments']}, failed: ${summary['failed_payments']}, total_amount: ${summary['total_amount']}',
          );
        }
        return data;
      } else {
        LoggerService.warning('Aucune donnée de paiements reçue');
        return null;
      }
    } catch (e) {
      LoggerService.error('Erreur lors de la récupération des paiements', e);
      return null;
    }
  }

  Future<Map<String, String>?> getReceipt(String paymentId) async {
    try {
      LoggerService.info('Récupération du reçu pour paiement: $paymentId');
      final response = await _apiService.get('payments/$paymentId/receipt');

      final data = response?['data'];
      if (data != null && data['receipt_url'] != null && data['download_url'] != null) {
        return {
          'receipt_url': data['receipt_url'] as String,
          'download_url': data['download_url'] as String,
        };
      }

      LoggerService.warning('Reçu indisponible pour $paymentId');
      return null;
    } catch (e) {
      LoggerService.error('Erreur lors de la récupération du reçu', e);
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
      LoggerService.error(
        'Erreur lors de la récupération des détails du paiement',
        e,
      );
      return null;
    }
  }
}
