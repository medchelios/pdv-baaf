import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';

class StatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallStatItem(
              'Total',
              '${stats['total_orders'] ?? 0}',
              AppConstants.brandBlue,
              Icons.shopping_cart_rounded,
            ),
            _buildVerticalDivider(),
            _buildSmallStatItem(
              'En attente',
              '${stats['pending_orders'] ?? 0}',
              AppConstants.warningColor,
              Icons.pending_rounded,
            ),
            _buildVerticalDivider(),
            _buildSmallStatItem(
              'Validées',
              '${stats['validated_orders'] ?? 0}',
              AppConstants.successColor,
              Icons.check_circle_rounded,
            ),
            _buildVerticalDivider(),
            _buildSmallStatItem(
              'Rejetées',
              '${stats['rejected_orders'] ?? 0}',
              AppConstants.errorColor,
              Icons.cancel_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 35,
      width: 1,
      decoration: BoxDecoration(
        color: AppConstants.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
}
