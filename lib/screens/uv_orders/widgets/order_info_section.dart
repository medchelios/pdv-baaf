import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class OrderInfoSection extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderInfoSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.brandWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.brandBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.brandBlue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de la commande',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppConstants.brandBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildInfoRow(context, 'Type', order['type_label'] ?? 'Commande UV'),
          _buildInfoRow(
            context,
            'Montant',
            order['formatted_amount'] ?? '0 GNF',
          ),
          _buildInfoRow(
            context,
            'Commission',
            order['bonus_amount'] != null
                ? '${order['bonus_amount']} GNF'
                : '0 GNF',
          ),
          _buildInfoRow(
            context,
            'Total avec commission',
            order['formatted_total_amount'] ?? '0 GNF',
          ),
          _buildInfoRow(context, 'Statut', order['status_label'] ?? 'Inconnu'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppConstants.brandBlue),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
