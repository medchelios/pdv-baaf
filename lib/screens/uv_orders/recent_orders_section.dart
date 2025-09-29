import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'widgets/orders_table.dart';
import 'widgets/orders_pagination.dart';
import 'order_details_screen.dart';

class RecentOrdersSection extends StatefulWidget {
  final List<Map<String, dynamic>>? recentOrders;
  final VoidCallback onRefresh;

  const RecentOrdersSection({
    super.key,
    required this.recentOrders,
    required this.onRefresh,
  });

  @override
  State<RecentOrdersSection> createState() => _RecentOrdersSectionState();
}

class _RecentOrdersSectionState extends State<RecentOrdersSection> {
  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final orders = widget.recentOrders ?? [];
    final totalPages = (orders.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, orders.length);
    final currentOrders = orders.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commandes Récentes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppConstants.brandBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingS),

        if (orders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            decoration: BoxDecoration(
              color: AppConstants.brandWhite,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: AppConstants.brandBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Center(child: Text('Aucune commande récente')),
          )
        else ...[
          OrdersTable(orders: currentOrders, onOrderTap: _showOrderDetails),
          if (totalPages > 1) ...[
            const SizedBox(height: AppConstants.paddingM),
            OrdersPagination(
              currentPage: _currentPage,
              totalPages: totalPages,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ],
        ],
      ],
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order),
          ),
        )
        .then((result) {
          // Si une action a été effectuée (validation/rejet), rafraîchir
          if (result == true) {
            widget.onRefresh();
          }
        });
  }
}
