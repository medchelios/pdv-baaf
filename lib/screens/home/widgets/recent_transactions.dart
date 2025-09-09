import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/user_data_service.dart';
import '../../dashboard_screen.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = UserDataService().recentTransactions ?? _getDefaultTransactions();
    
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
          ...transactions.take(3).map((transaction) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTransactionItem(
              icon: _getTransactionIcon(transaction['type'] ?? ''),
              title: transaction['title'] ?? 'Transaction',
              subtitle: transaction['subtitle'] ?? 'Récent',
              amount: transaction['amount'] ?? '+0 GNF',
              isPositive: transaction['isPositive'] ?? true,
            ),
          )),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDefaultTransactions() {
    return [
      {
        'type': 'prepaid',
        'title': 'Prépayé',
        'subtitle': 'Il y a 2 min',
        'amount': '+15,000 GNF',
        'isPositive': true,
      },
      {
        'type': 'postpaid',
        'title': 'Postpayé',
        'subtitle': 'Il y a 5 min',
        'amount': '+25,000 GNF',
        'isPositive': true,
      },
      {
        'type': 'uv_order',
        'title': 'Commande UV',
        'subtitle': 'Il y a 10 min',
        'amount': '+10,000 GNF',
        'isPositive': true,
      },
    ];
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'prepaid':
        return Icons.flash_on_rounded;
      case 'postpaid':
        return Icons.receipt_long_rounded;
      case 'uv_order':
        return Icons.shopping_cart_rounded;
      default:
        return Icons.payment_rounded;
    }
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
