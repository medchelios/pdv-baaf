import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class BalanceSection extends StatelessWidget {
  final double principalBalance;
  final double commissionBalance;
  final VoidCallback? onTransferTap;
  final VoidCallback? onDetailsTap;

  const BalanceSection({
    super.key,
    required this.principalBalance,
    required this.commissionBalance,
    this.onTransferTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mes Comptes',
                style: AppConstants.heading3,
              ),
              TextButton(
                onPressed: onDetailsTap,
                child: Text(
                  'Voir détails',
                  style: TextStyle(
                    color: AppConstants.brandBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          Row(
            children: [
              Expanded(
                child: _buildBalanceCard(
                  'Principal',
                  principalBalance,
                  AppConstants.brandBlue,
                  Icons.account_balance_wallet_rounded,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildBalanceCard(
                  'Commission',
                  commissionBalance,
                  AppConstants.brandOrange,
                  Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTransferTap,
              icon: const Icon(Icons.swap_horiz_rounded, size: 20),
              label: const Text('Transfert Commission → Principal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.successColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatAmount(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
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
