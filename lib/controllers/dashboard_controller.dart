import 'package:flutter/material.dart';

/// Contrôleur pour le dashboard PDV
/// TODO: Intégrer les vraies APIs du backend
class DashboardController extends ChangeNotifier {
  // État de chargement
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Statistiques UV
  Map<String, dynamic>? _uvStats;
  Map<String, dynamic>? get uvStats => _uvStats;

  // Statistiques Paiements
  Map<String, dynamic>? _paymentStats;
  Map<String, dynamic>? get paymentStats => _paymentStats;

  // Paiements récents
  List<Map<String, dynamic>> _recentPayments = [];
  List<Map<String, dynamic>> get recentPayments => _recentPayments;

  // Erreur
  String? _error;
  String? get error => _error;

  /// Charger toutes les données du dashboard
  Future<void> loadDashboardData() async {
    _setLoading(true);
    try {
      // Charger en parallèle
      await Future.wait([
        loadUvStats(),
        loadPaymentStats(),
        loadRecentPayments(),
      ]);
      
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement du dashboard: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Charger les statistiques UV
  /// TODO: Appeler l'API GET /api/mobile/agent/stats/uv-orders
  Future<void> loadUvStats() async {
    try {
      // TODO: Appeler l'API des stats UV
      await Future.delayed(const Duration(milliseconds: 500)); // Simulation
      
      // Données fictives pour le design
      _uvStats = {
        'total_orders': 25,
        'pending_orders': 5,
        'validated_orders': 18,
        'rejected_orders': 2,
        'total_amount': 1250000,
      };
    } catch (e) {
      _error = 'Erreur lors du chargement des stats UV: $e';
    }
  }

  /// Charger les statistiques de paiements
  /// TODO: Appeler l'API GET /api/mobile/agent/stats/payments
  Future<void> loadPaymentStats() async {
    try {
      // TODO: Appeler l'API des stats paiements
      await Future.delayed(const Duration(milliseconds: 500)); // Simulation
      
      // Données fictives pour le design
      _paymentStats = {
        'total_payments': 4,
        'completed_payments': 4,
        'successful_payments': 4,
        'failed_payments': 0,
        'total_amount': 424596,
      };
    } catch (e) {
      _error = 'Erreur lors du chargement des stats paiements: $e';
    }
  }

  /// Charger les paiements récents
  /// TODO: Appeler l'API GET /api/mobile/agent/payments/recent
  Future<void> loadRecentPayments() async {
    try {
      // TODO: Appeler l'API des paiements récents
      await Future.delayed(const Duration(milliseconds: 500)); // Simulation
      
      // Données fictives pour le design
      _recentPayments = [
        {
          'id': 1,
          'customer_name': 'Mamadou Diallo',
          'amount': 15000,
          'status': 'completed',
          'method': 'mobile_money',
          'date': '2024-01-15 16:45:00',
          'reference': 'PAY-001',
        },
        {
          'id': 2,
          'customer_name': 'Fatou Camara',
          'amount': 25000,
          'status': 'completed',
          'method': 'cash',
          'date': '2024-01-15 15:30:00',
          'reference': 'PAY-002',
        },
        {
          'id': 3,
          'customer_name': 'Ibrahima Bah',
          'amount': 35000,
          'status': 'completed',
          'method': 'mobile_money',
          'date': '2024-01-15 14:15:00',
          'reference': 'PAY-003',
        },
        {
          'id': 4,
          'customer_name': 'Aissatou Barry',
          'amount': 20000,
          'status': 'completed',
          'method': 'card',
          'date': '2024-01-15 13:00:00',
          'reference': 'PAY-004',
        },
        {
          'id': 5,
          'customer_name': 'Ousmane Traoré',
          'amount': 45000,
          'status': 'completed',
          'method': 'mobile_money',
          'date': '2024-01-15 11:30:00',
          'reference': 'PAY-005',
        },
      ];
    } catch (e) {
      _error = 'Erreur lors du chargement des paiements récents: $e';
    }
  }

  /// Formater le montant en GNF
  String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M GNF';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K GNF';
    } else {
      return '${amount.toStringAsFixed(0)} GNF';
    }
  }

  /// Obtenir le statut formaté
  String getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Complété';
      case 'pending':
        return 'En attente';
      case 'failed':
        return 'Échoué';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  /// Obtenir la méthode de paiement formatée
  String getPaymentMethodLabel(String method) {
    switch (method) {
      case 'mobile_money':
        return 'Mobile Money';
      case 'card':
        return 'Carte bancaire';
      case 'cash':
        return 'Espèces';
      default:
        return method;
    }
  }

  /// Obtenir la couleur du statut
  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Nettoyer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
