import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../utils/format_utils.dart';

class OrdersTable extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final Function(Map<String, dynamic>) onOrderTap;

  const OrdersTable({
    super.key,
    required this.orders,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.brandWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.brandBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTableHeader(context),
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isLast = index == orders.length - 1;
            return _buildTableRow(context, order, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.brandBlue.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusM),
          topRight: Radius.circular(AppConstants.radiusM),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Type',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Montant',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Statut',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    Map<String, dynamic> order,
    bool isLast,
  ) {
    return InkWell(
      onTap: () => onOrderTap(order),
      child: Container(
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppConstants.brandBlue.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingS,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  order['type_label'] ?? 'Inconnu',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getTypeColor(order['type'] as String),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  order['formatted_total_amount']?.replaceAll(' GNF', '') ??
                      '0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  FormatUtils.formatDate(order['requested_at'] ?? ''),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  order['status_label'] ?? 'Inconnu',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(order['status'] as String),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'order':
        return AppConstants.brandBlue;
      case 'credit_request':
        return AppConstants.brandOrange;
      default:
        return AppConstants.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'validated':
        return AppConstants.successColor;
      case 'pending_validation':
        return AppConstants.warningColor;
      case 'rejected_by_validator':
      case 'rejected_by_admin':
        return AppConstants.errorColor;
      default:
        return AppConstants.brandBlue;
    }
  }
}
