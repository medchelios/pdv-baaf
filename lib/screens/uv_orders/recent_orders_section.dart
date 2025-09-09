import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';
import '../../utils/format_utils.dart';

class RecentOrdersSection extends StatelessWidget {
  final List<Map<String, dynamic>>? recentOrders;
  final VoidCallback onRefresh;

  const RecentOrdersSection({
    super.key,
    required this.recentOrders,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Commandes Récentes',
              style: AppConstants.heading2.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              icon: Icon(
                Icons.refresh,
                color: AppConstants.brandBlue,
              ),
              tooltip: 'Actualiser',
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recentOrders == null || recentOrders!.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.paddingXL),
                    child: Text('Aucune commande récente'),
                  ),
                )
              else
                _buildOrdersTable(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersTable(BuildContext context) {
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
          // En-tête du tableau
          Container(
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
                  flex: 3,
                  child: Text(
                    'Montant',
                    style: AppConstants.bodyMedium.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: AppConstants.bodyMedium.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Statut',
                    style: AppConstants.bodyMedium.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lignes du tableau
          ...recentOrders!.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isLast = index == recentOrders!.length - 1;
            
            return Container(
              decoration: BoxDecoration(
                border: isLast ? null : Border(
                  bottom: BorderSide(
                    color: AppConstants.brandBlue.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: _buildTableRow(context, order, isLast),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Map<String, dynamic> order, bool isLast) {
    return InkWell(
      onTap: () => _showOrderDetails(context, order),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                order['formatted_total_amount'] ?? '0 GNF',
                style: AppConstants.bodyMedium.copyWith(
                  color: AppConstants.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                FormatUtils.formatDate(order['requested_at'] ?? ''),
                style: AppConstants.bodySmall.copyWith(
                  color: AppConstants.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                order['status_label'] ?? 'Inconnu',
                style: AppConstants.bodySmall.copyWith(
                  color: _getStatusColor(order['status'] as String),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.brandWhite,
        title: Text(
          'Détails de la commande',
          style: AppConstants.heading2.copyWith(
            color: AppConstants.brandBlue,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', order['type_label'] ?? 'Commande UV'),
              _buildDetailRow('Montant', order['formatted_total_amount'] ?? '0 GNF'),
              _buildDetailRow('Statut', order['status_label'] ?? 'Inconnu'),
              _buildDetailRow('Description', order['description'] ?? 'Aucune description'),
              _buildDetailRow('Demandé par', order['requester_name'] ?? 'N/A'),
              _buildDetailRow('Date de demande', order['requested_at'] ?? ''),
              if (order['validated_at'] != null)
                _buildDetailRow('Date de validation', order['validated_at']),
              if (order['rejected_at'] != null)
                _buildDetailRow('Date de rejet', order['rejected_at']),
              _buildDetailRow('Validateur', order['validator_name'] ?? 'Non assigné'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Fermer',
              style: AppConstants.bodyMedium.copyWith(
                color: AppConstants.brandBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppConstants.bodyMedium.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppConstants.bodyMedium.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'validated':
        return AppConstants.brandOrange;
      case 'pending_validation':
      case 'rejected_by_validator':
      case 'rejected_by_admin':
      default:
        return AppConstants.brandBlue;
    }
  }
}
