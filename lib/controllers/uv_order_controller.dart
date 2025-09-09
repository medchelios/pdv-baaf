import 'package:flutter/material.dart';
import '../services/uv_order_service.dart';

/// Contrôleur pour la gestion des commandes UV
class UvOrderController extends ChangeNotifier {
  final UVOrderService _uvOrderService = UVOrderService();
  // État de chargement
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Liste des commandes UV
  List<Map<String, dynamic>> _uvOrders = [];
  List<Map<String, dynamic>> get uvOrders => _uvOrders;

  // Statistiques UV
  Map<String, dynamic>? _uvStats;
  Map<String, dynamic>? get uvStats => _uvStats;

  // Erreur
  String? _error;
  String? get error => _error;

  /// Charger la liste des commandes UV
  Future<void> loadUvOrders() async {
    _setLoading(true);
    try {
      final orders = await _uvOrderService.getRecentOrders();
      _uvOrders = orders ?? [];
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des commandes UV: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  /// Créer une nouvelle commande UV
  Future<bool> createUvOrder(Map<String, dynamic> orderData) async {
    _setLoading(true);
    try {
      final result = await _uvOrderService.createOrder(
        amount: orderData['amount']?.toDouble() ?? 0.0,
        description: orderData['description'] ?? '',
        type: orderData['type'] ?? 'order',
      );
      
      if (result != null) {
        // Recharger les données après création
        await loadUvOrders();
        await loadUvStats();
        _error = null;
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Erreur lors de la création de la commande: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Valider une commande UV
  Future<bool> validateUvOrder(int orderId, {String? comment}) async {
    _setLoading(true);
    try {
      final success = await _uvOrderService.validateOrder(
        orderId: orderId,
        comment: comment,
      );
      
      if (success) {
        // Recharger les données après validation
        await loadUvOrders();
        await loadUvStats();
        _error = null;
      }
      
      return success;
    } catch (e) {
      _error = 'Erreur lors de la validation: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Rejeter une commande UV
  /// TODO: Appeler l'API PUT /api/mobile/agent/uv-orders/{id}/reject
  Future<bool> rejectUvOrder(int orderId) async {
    _setLoading(true);
    try {
      // TODO: Appeler l'API de rejet
      await Future.delayed(const Duration(seconds: 1)); // Simulation
      
      // TODO: Mettre à jour le statut de la commande
      final index = _uvOrders.indexWhere((order) => order['id'] == orderId);
      if (index != -1) {
        _uvOrders[index]['status'] = 'rejected';
      }
      
      _error = null;
      return true;
    } catch (e) {
      _error = 'Erreur lors du rejet: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Charger les statistiques UV
  Future<void> loadUvStats() async {
    _setLoading(true);
    try {
      final stats = await _uvOrderService.getStats();
      _uvStats = stats;
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des stats UV: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Obtenir les commandes par statut
  List<Map<String, dynamic>> getOrdersByStatus(String status) {
    return _uvOrders.where((order) => order['status'] == status).toList();
  }

  /// Obtenir une commande par ID
  Map<String, dynamic>? getOrderById(int id) {
    try {
      return _uvOrders.firstWhere((order) => order['id'] == id);
    } catch (e) {
      return null;
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
