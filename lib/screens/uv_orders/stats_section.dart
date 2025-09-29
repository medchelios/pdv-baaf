import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';

class StatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques UV',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppConstants.brandBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingS),
        CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallStatItem(
                  context,
                  'Total',
                  '${stats['total_orders'] ?? 0}',
                  AppConstants.brandBlue,
                  Icons.shopping_cart_rounded,
                ),
                _buildVerticalDivider(),
                _buildSmallStatItem(
                  context,
                  'En attente',
                  '${stats['pending_orders'] ?? 0}',
                  AppConstants.warningColor,
                  Icons.pending_rounded,
                ),
                _buildVerticalDivider(),
                _buildSmallStatItem(
                  context,
                  'Validées',
                  '${stats['validated_orders'] ?? 0}',
                  AppConstants.successColor,
                  Icons.check_circle_rounded,
                ),
                _buildVerticalDivider(),
                _buildSmallStatItem(
                  context,
                  'Rejetées',
                  '${stats['rejected_orders'] ?? 0}',
                  AppConstants.errorColor,
                  Icons.cancel_rounded,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppConstants.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      decoration: BoxDecoration(
        color: AppConstants.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
}
