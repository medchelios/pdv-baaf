import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../dashboard_screen.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions Récentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                },
                child: const Text(
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
          const SizedBox(height: 16),
          _buildTransactionItem(
            icon: Icons.flash_on_rounded,
            title: 'Prépayé',
            subtitle: 'Il y a 2 min',
            amount: '+15,000 GNF',
            isPositive: true,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            icon: Icons.receipt_long_rounded,
            title: 'Postpayé',
            subtitle: 'Il y a 5 min',
            amount: '+25,000 GNF',
            isPositive: true,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            icon: Icons.shopping_cart_rounded,
            title: 'Commande UV',
            subtitle: 'Il y a 10 min',
            amount: '+10,000 GNF',
            isPositive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: AppConstants.brandBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPositive ? AppConstants.successColor : AppConstants.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
