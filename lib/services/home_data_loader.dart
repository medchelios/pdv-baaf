import 'logger_service.dart';
import 'uv_order_service.dart';
import 'payment_service.dart';
import 'user_data_service.dart';

class HomeDataLoader {
  static final HomeDataLoader _instance = HomeDataLoader._internal();
  factory HomeDataLoader() => _instance;
  HomeDataLoader._internal();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHomeData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    LoggerService.info('Chargement des données de la page d\'accueil');
    print('HomeDataLoader - Début du chargement des données');

    try {
      print('HomeDataLoader - Vérification du cache des soldes: ${UserDataService().hasValidBalanceCache}');
      if (!UserDataService().hasValidBalanceCache) {
        print('HomeDataLoader - Chargement du solde des comptes');
        await _loadAccountBalance();
      }

      print('HomeDataLoader - Vérification du cache des transactions: ${UserDataService().hasValidTransactionsCache}');
      if (!UserDataService().hasValidTransactionsCache) {
        print('HomeDataLoader - Chargement des transactions récentes');
        await _loadRecentTransactions();
      }

      LoggerService.info('Données de la page d\'accueil chargées avec succès');
      print('HomeDataLoader - Données chargées avec succès');
    } catch (e) {
      LoggerService.error('Erreur lors du chargement des données de la page d\'accueil', e);
      print('HomeDataLoader - Erreur: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _loadAccountBalance() async {
    try {
      LoggerService.info('Chargement du solde des comptes');
      final balanceData = await UVOrderService().getAccountBalance();
      
      if (balanceData != null) {
        UserDataService().updateAccountBalance(balanceData);
        LoggerService.info('Solde des comptes chargé et mis en cache: $balanceData');
      } else {
        LoggerService.warning('Aucune donnée de solde reçue');
      }
    } catch (e) {
      LoggerService.error('Erreur lors du chargement du solde des comptes', e);
    }
  }

  Future<void> _loadRecentTransactions() async {
    try {
      LoggerService.info('Chargement des paiements récents');
      final payments = await PaymentService().getRecentPayments(limit: 5);
      
      if (payments != null && payments.isNotEmpty) {
        final transactions = payments.map((payment) => _convertPaymentToTransaction(payment)).toList();
        UserDataService().updateRecentTransactions(transactions);
        LoggerService.info('${transactions.length} paiements récents chargés et mis en cache');
      } else {
        LoggerService.warning('Aucun paiement récent disponible');
        UserDataService().updateRecentTransactions([]);
      }
    } catch (e) {
      LoggerService.error('Erreur lors du chargement des paiements récents', e);
      UserDataService().updateRecentTransactions([]);
    }
  }

  Map<String, dynamic> _convertPaymentToTransaction(Map<String, dynamic> payment) {
    final amount = payment['amount'] ?? 0;
    final formattedAmount = payment['formatted_amount'] ?? _formatAmount(amount);
    final status = payment['status'] ?? 'completed';
    final isPositive = status == 'completed';
    
    return {
      'id': payment['id'],
      'type': _getPaymentType(payment['payment_method'] ?? ''),
      'title': _getPaymentTitle(payment['payment_method'] ?? ''),
      'subtitle': _formatTimeAgo(payment['created_at'] ?? ''),
      'amount': formattedAmount,
      'isPositive': isPositive,
      'reference': payment['reference'] ?? '',
      'period': payment['formatted_period'] ?? '',
      'status': status,
      'status_label': payment['status_label'] ?? '',
      'subscriber_name': payment['subscriber_name'] ?? '',
    };
  }

  String _getPaymentType(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'mobile_money':
        return 'mobile_money';
      case 'cash':
        return 'cash';
      case 'bank':
        return 'bank';
      default:
        return 'payment';
    }
  }

  String _getPaymentTitle(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'mobile_money':
        return 'Mobile Money';
      case 'cash':
        return 'Espèces';
      case 'bank':
        return 'Banque';
      default:
        return 'Paiement';
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount is num) {
      return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} GNF';
    }
    return '0 GNF';
  }

  String _formatTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 1) {
        return 'À l\'instant';
      } else if (difference.inMinutes < 60) {
        return 'Il y a ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return 'Il y a ${difference.inHours}h';
      } else {
        return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
      }
    } catch (e) {
      return 'Récent';
    }
  }


  Future<void> refreshData() async {
    LoggerService.info('Rechargement forcé des données');
    await UserDataService().clearCache();
    await loadHomeData();
  }
}
