import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';
import '../../services/logger_service.dart';
import 'widgets/orders_table.dart';
import 'order_details_screen.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  final UVOrderService _uvOrderService = UVOrderService();

  List<Map<String, dynamic>>? _orders;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _uvOrderService.getHistory(limit: 50);
      if (!mounted) return;
      setState(() {
        _orders = result ?? <Map<String, dynamic>>[];
        _isLoading = false;
      });
    } catch (e) {
      LoggerService.error('Erreur lors du chargement de l\'historique', e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  void _onOrderTap(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des commandes'),
        backgroundColor: AppConstants.brandBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _loadOrders(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildContent()),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return const SizedBox.shrink(); // Temporairement désactivé
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_orders == null || _orders!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              'Aucune commande trouvée',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              'Ajustez vos filtres pour voir plus de résultats',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: OrdersTable(orders: _orders!, onOrderTap: _onOrderTap),
      ),
    );
  }

  Widget _buildPagination() {
    return const SizedBox.shrink(); // Temporairement désactivé
  }
}
