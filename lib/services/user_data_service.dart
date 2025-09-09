import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger_service.dart';

class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  Map<String, dynamic>? _accountBalance;
  List<Map<String, dynamic>>? _recentTransactions;
  DateTime? _lastBalanceUpdate;
  DateTime? _lastTransactionsUpdate;

  // Cache duration
  static const Duration _cacheDuration = Duration(minutes: 5);

  Map<String, dynamic>? get accountBalance => _accountBalance;
  List<Map<String, dynamic>>? get recentTransactions => _recentTransactions;

  bool get hasValidBalanceCache => 
    _accountBalance != null && 
    _lastBalanceUpdate != null && 
    DateTime.now().difference(_lastBalanceUpdate!) < _cacheDuration;

  bool get hasValidTransactionsCache => 
    _recentTransactions != null && 
    _lastTransactionsUpdate != null && 
    DateTime.now().difference(_lastTransactionsUpdate!) < _cacheDuration;

  /// Initialiser le service avec les données en cache
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Charger le solde en cache
      final balanceJson = prefs.getString('cached_account_balance');
      if (balanceJson != null) {
        _accountBalance = jsonDecode(balanceJson);
        final balanceTimestamp = prefs.getInt('cached_balance_timestamp');
        if (balanceTimestamp != null) {
          _lastBalanceUpdate = DateTime.fromMillisecondsSinceEpoch(balanceTimestamp);
        }
      }

      // Charger les transactions en cache
      final transactionsJson = prefs.getString('cached_recent_transactions');
      if (transactionsJson != null) {
        final List<dynamic> transactionsList = jsonDecode(transactionsJson);
        _recentTransactions = transactionsList.cast<Map<String, dynamic>>();
        final transactionsTimestamp = prefs.getInt('cached_transactions_timestamp');
        if (transactionsTimestamp != null) {
          _lastTransactionsUpdate = DateTime.fromMillisecondsSinceEpoch(transactionsTimestamp);
        }
      }

      LoggerService.info('UserDataService initialisé avec cache');
    } catch (e) {
      LoggerService.error('Erreur lors de l\'initialisation de UserDataService', e);
    }
  }

  /// Mettre à jour le solde des comptes
  void updateAccountBalance(Map<String, dynamic> balance) {
    _accountBalance = balance;
    _lastBalanceUpdate = DateTime.now();
    _saveBalanceToCache();
    LoggerService.info('Solde des comptes mis à jour');
  }

  /// Mettre à jour les transactions récentes
  void updateRecentTransactions(List<Map<String, dynamic>> transactions) {
    _recentTransactions = transactions;
    _lastTransactionsUpdate = DateTime.now();
    _saveTransactionsToCache();
    LoggerService.info('Transactions récentes mises à jour');
  }

  /// Sauvegarder le solde en cache
  Future<void> _saveBalanceToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_account_balance', jsonEncode(_accountBalance));
      await prefs.setInt('cached_balance_timestamp', _lastBalanceUpdate!.millisecondsSinceEpoch);
    } catch (e) {
      LoggerService.error('Erreur lors de la sauvegarde du cache de solde', e);
    }
  }

  /// Sauvegarder les transactions en cache
  Future<void> _saveTransactionsToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_recent_transactions', jsonEncode(_recentTransactions));
      await prefs.setInt('cached_transactions_timestamp', _lastTransactionsUpdate!.millisecondsSinceEpoch);
    } catch (e) {
      LoggerService.error('Erreur lors de la sauvegarde du cache de transactions', e);
    }
  }

  /// Nettoyer le cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_account_balance');
      await prefs.remove('cached_balance_timestamp');
      await prefs.remove('cached_recent_transactions');
      await prefs.remove('cached_transactions_timestamp');
      
      _accountBalance = null;
      _recentTransactions = null;
      _lastBalanceUpdate = null;
      _lastTransactionsUpdate = null;
      
      LoggerService.info('Cache UserDataService nettoyé');
    } catch (e) {
      LoggerService.error('Erreur lors du nettoyage du cache', e);
    }
  }
}
