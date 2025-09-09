import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class StatsSection extends StatelessWidget {
  final Map<String, dynamic>? uvStats;
  final Map<String, dynamic>? paymentStats;
  final VoidCallback? onViewAllStats;

  const StatsSection({
    super.key,
    this.uvStats,
    this.paymentStats,
    this.onViewAllStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aperçu du jour',
                style: AppConstants.heading3,
              ),
              TextButton(
                onPressed: onViewAllStats,
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    color: AppConstants.brandBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Commandes UV',
                  '${uvStats?['total_orders'] ?? 0}',
                  '${uvStats?['pending_orders'] ?? 0} en attente',
                  AppConstants.brandOrange,
                  Icons.shopping_cart_rounded,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildStatsCard(
                  'Paiements',
                  '${paymentStats?['total_payments'] ?? 0}',
                  '${paymentStats?['successful_payments'] ?? 0} réussis',
                  AppConstants.brandBlue,
                  Icons.payment_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Montant UV',
                  _formatAmount(uvStats?['total_amount'] ?? 0),
                  'Total commandes',
                  AppConstants.successColor,
                  Icons.attach_money_rounded,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildStatsCard(
                  'Montant Paiements',
                  _formatAmount(paymentStats?['total_amount'] ?? 0),
                  'Total collecté',
                  AppConstants.warningColor,
                  Icons.account_balance_wallet_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M GNF';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K GNF';
    } else {
      return '${amount.toStringAsFixed(0)} GNF';
    }
  }
}
