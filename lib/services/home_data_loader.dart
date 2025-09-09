import 'logger_service.dart';
import 'uv_order_service.dart';
import 'user_data_service.dart';

class HomeDataLoader {
  static final HomeDataLoader _instance = HomeDataLoader._internal();
  factory HomeDataLoader() => _instance;
  HomeDataLoader._internal();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Charger toutes les données nécessaires pour la page d'accueil
  Future<void> loadHomeData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    LoggerService.info('Chargement des données de la page d\'accueil');

    try {
      // Charger le solde des comptes si pas en cache
      if (!UserDataService().hasValidBalanceCache) {
        await _loadAccountBalance();
      }

      // Charger les transactions récentes si pas en cache
      if (!UserDataService().hasValidTransactionsCache) {
        await _loadRecentTransactions();
      }

      LoggerService.info('Données de la page d\'accueil chargées avec succès');
    } catch (e) {
      LoggerService.error('Erreur lors du chargement des données de la page d\'accueil', e);
    } finally {
      _isLoading = false;
    }
  }

  /// Charger le solde des comptes
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

  /// Charger les transactions récentes
  Future<void> _loadRecentTransactions() async {
    try {
      LoggerService.info('Chargement des transactions récentes');
      // TODO: Implémenter l'API des transactions récentes
      // Pour l'instant, on utilise les données par défaut
      final defaultTransactions = [
        {
          'type': 'prepaid',
          'title': 'Prépayé',
          'subtitle': 'Il y a 2 min',
          'amount': '+15,000 GNF',
          'isPositive': true,
        },
        {
          'type': 'postpaid',
          'title': 'Postpayé',
          'subtitle': 'Il y a 5 min',
          'amount': '+25,000 GNF',
          'isPositive': true,
        },
        {
          'type': 'uv_order',
          'title': 'Commande UV',
          'subtitle': 'Il y a 10 min',
          'amount': '+10,000 GNF',
          'isPositive': true,
        },
      ];
      
      UserDataService().updateRecentTransactions(defaultTransactions);
      LoggerService.info('Transactions récentes chargées et mises en cache');
    } catch (e) {
      LoggerService.error('Erreur lors du chargement des transactions récentes', e);
    }
  }

  /// Forcer le rechargement des données
  Future<void> refreshData() async {
    LoggerService.info('Rechargement forcé des données');
    await UserDataService().clearCache();
    await loadHomeData();
  }
}
