import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class StatsController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _dailyStats;
  Map<String, dynamic>? _monthlyStats;
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, dynamic>? get dailyStats => _dailyStats;
  Map<String, dynamic>? get monthlyStats => _monthlyStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Stats calculées
  int get todayPayments => _dailyStats?['payments_count'] ?? 0;
  double get todayAmount => (_dailyStats?['total_amount'] ?? 0).toDouble();
  int get monthPayments => _monthlyStats?['payments_count'] ?? 0;
  double get monthAmount => (_monthlyStats?['total_amount'] ?? 0).toDouble();

  // Charger les stats du jour
  Future<void> loadDailyStats() async {
    _setLoading(true);
    try {
      final result = await _apiService.getDailyStats();
      if (result['success'] == true) {
        _dailyStats = result['data'];
        _error = null;
      } else {
        _error = result['message'] ?? 'Erreur lors du chargement des stats';
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Charger les stats du mois
  Future<void> loadMonthlyStats() async {
    _setLoading(true);
    try {
      final result = await _apiService.getMonthlyStats();
      if (result['success'] == true) {
        _monthlyStats = result['data'];
        _error = null;
      } else {
        _error = result['message'] ?? 'Erreur lors du chargement des stats';
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Charger toutes les stats
  Future<void> loadAllStats() async {
    await Future.wait([
      loadDailyStats(),
      loadMonthlyStats(),
    ]);
  }

  // Rafraîchir les stats
  Future<void> refreshStats() async {
    await loadAllStats();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Formater le montant
  String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M GNF';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K GNF';
    } else {
      return '${amount.toStringAsFixed(0)} GNF';
    }
  }

  // Formater le pourcentage de croissance
  String formatGrowthPercentage(double current, double previous) {
    if (previous == 0) return '+100%';
    final growth = ((current - previous) / previous) * 100;
    return '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%';
  }
}
