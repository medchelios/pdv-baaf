import 'package:flutter/material.dart';
import '../services/uv_order_service.dart';

class UvOrderController extends ChangeNotifier {
  final UVOrderService _uvOrderService = UVOrderService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _uvOrders = [];
  List<Map<String, dynamic>> get uvOrders => _uvOrders;

  Map<String, dynamic>? _uvStats;
  Map<String, dynamic>? get uvStats => _uvStats;

  String? _error;
  String? get error => _error;

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

  Future<bool> createUvOrder(Map<String, dynamic> orderData) async {
    _setLoading(true);
    try {
      final result = await _uvOrderService.createOrder(
        amount: orderData['amount']?.toDouble() ?? 0.0,
        description: orderData['description'] ?? '',
      );

      if (result != null) {
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

  Future<bool> createRechargeRequest(Map<String, dynamic> rechargeData) async {
    _setLoading(true);
    try {
      final result = await _uvOrderService.createRechargeRequest(
        amount: rechargeData['amount']?.toDouble() ?? 0.0,
        description: rechargeData['description'] ?? '',
      );

      if (result != null) {
        await loadUvOrders();
        await loadUvStats();
        _error = null;
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Erreur lors de la création de la demande de recharge: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> validateUvOrder(int orderId, {String? comment}) async {
    _setLoading(true);
    try {
      final success = await _uvOrderService.validateOrder(
        orderId: orderId,
        comment: comment,
      );

      if (success) {
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

  Future<bool> rejectUvOrder(int orderId, {required String comment}) async {
    _setLoading(true);
    try {
      final success = await _uvOrderService.rejectOrder(
        orderId: orderId,
        comment: comment,
      );

      if (success) {
        await loadUvOrders();
        await loadUvStats();
        _error = null;
      }

      return success;
    } catch (e) {
      _error = 'Erreur lors du rejet: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

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

  List<Map<String, dynamic>> getOrdersByStatus(String status) {
    return _uvOrders.where((order) => order['status'] == status).toList();
  }

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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
