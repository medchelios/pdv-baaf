import 'package:flutter/material.dart';

/// Contrôleur pour la gestion des comptes
/// TODO: Intégrer les vraies APIs du backend
class AccountController extends ChangeNotifier {
  // État de chargement
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Solde principal
  double _principalBalance = 0.0;
  double get principalBalance => _principalBalance;

  // Solde commission
  double _commissionBalance = 0.0;
  double get commissionBalance => _commissionBalance;

  // Historique des transferts
  List<Map<String, dynamic>> _transfers = [];
  List<Map<String, dynamic>> get transfers => _transfers;

  // Erreur
  String? _error;
  String? get error => _error;

  /// Charger les soldes des comptes
  /// TODO: Appeler l'API GET /api/mobile/agent/accounts/balance
  Future<void> loadAccountBalances() async {
    _setLoading(true);
    try {
      // TODO: Appeler l'API des soldes
      await Future.delayed(const Duration(seconds: 1)); // Simulation
      
      // Données fictives pour le design
      _principalBalance = 1500000.0; // 1.5M GNF
      _commissionBalance = 250000.0; // 250K GNF
      
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des soldes: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Effectuer un transfert commission → principal
  /// TODO: Appeler l'API POST /api/mobile/agent/accounts/transfer
  Future<bool> transferCommissionToPrincipal(double amount) async {
    _setLoading(true);
    try {
      // Vérifier que le montant est valide
      if (amount <= 0 || amount > _commissionBalance) {
        _error = 'Montant invalide ou insuffisant';
        return false;
      }

      // TODO: Appeler l'API de transfert
      await Future.delayed(const Duration(seconds: 1)); // Simulation
      
      // Simulation du transfert
      _commissionBalance -= amount;
      _principalBalance += amount;
      
      // Ajouter à l'historique
      _transfers.insert(0, {
        'id': _transfers.length + 1,
        'type': 'commission_to_principal',
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
        'status': 'completed',
      });
      
      _error = null;
      return true;
    } catch (e) {
      _error = 'Erreur lors du transfert: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Charger l'historique des transferts
  /// TODO: Appeler l'API GET /api/mobile/agent/accounts/transfers
  Future<void> loadTransferHistory() async {
    _setLoading(true);
    try {
      // TODO: Appeler l'API de l'historique
      await Future.delayed(const Duration(seconds: 1)); // Simulation
      
      // Données fictives pour le design
      _transfers = [
        {
          'id': 1,
          'type': 'commission_to_principal',
          'amount': 50000.0,
          'date': '2024-01-15 14:30:00',
          'status': 'completed',
        },
        {
          'id': 2,
          'type': 'commission_to_principal',
          'amount': 75000.0,
          'date': '2024-01-14 09:15:00',
          'status': 'completed',
        },
        // TODO: Ajouter plus de données de test
      ];
      
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement de l\'historique: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
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

  /// Obtenir le total des transferts
  double get totalTransfers {
    return _transfers
        .where((transfer) => transfer['status'] == 'completed')
        .fold(0.0, (sum, transfer) => sum + (transfer['amount'] as double));
  }

  /// Obtenir les transferts par statut
  List<Map<String, dynamic>> getTransfersByStatus(String status) {
    return _transfers.where((transfer) => transfer['status'] == status).toList();
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
