import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class OrderDetailsSection extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsSection({super.key, required this.order});

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
            'Détails supplémentaires',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppConstants.brandBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildInfoRow(
            context,
            'Description',
            order['description'] ?? 'Aucune description',
          ),
          _buildInfoRow(
            context,
            'Demandé par',
            order['requester_name'] ?? 'N/A',
          ),
          _buildInfoRow(
            context,
            'Date de demande',
            order['requested_at'] ?? '',
          ),
          if (order['validated_at'] != null)
            _buildInfoRow(context, 'Date de validation', order['validated_at']),
          if (order['rejected_at'] != null)
            _buildInfoRow(context, 'Date de rejet', order['rejected_at']),
          _buildInfoRow(
            context,
            'Validateur',
            order['validator_name'] ?? 'Non assigné',
          ),
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
