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
                  ...transactions.take(5).map((transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildTransactionItem(
                      icon: _getTransactionIcon(transaction['type'] ?? ''),
                      title: transaction['title'] ?? 'Paiement',
                      subtitle: transaction['subtitle'] ?? 'Récent',
                      amount: transaction['amount'] ?? '0 GNF',
                      isPositive: transaction['isPositive'] ?? true,
                      reference: transaction['reference'],
                      period: transaction['period'],
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
    String? reference,
    String? period,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Afficher les détails du paiement
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppConstants.brandBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppConstants.brandBlue,
                size: 16,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  if (reference != null && reference.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Ref: $reference',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                  if (period != null && period.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Période: $period',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                if (isPositive) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppConstants.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Crédit',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppConstants.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppConstants.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Débit',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppConstants.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
