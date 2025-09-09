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
          style: AppConstants.heading2.copyWith(
            color: AppConstants.brandBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
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
        ),
      ],
    );
  }

  Widget _buildSmallStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppConstants.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 50,
      width: 1,
      decoration: BoxDecoration(
        color: AppConstants.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
}
