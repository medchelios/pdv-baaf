import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/user_data_service.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final balanceData = UserDataService().accountBalance;
    final principalBalance = balanceData?['formatted_principal_balance'] ?? '0 GNF';
    final commissionBalance = balanceData?['formatted_commission_balance'] ?? '0 GNF';
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.brandOrange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.brandOrange.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes comptes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.visibility_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Principal',
                  principalBalance,
                  Icons.account_balance_wallet,
                  Colors.white,
                  CrossAxisAlignment.start,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildBalanceItem(
                  'Commission',
                  commissionBalance,
                  Icons.trending_up,
                  Colors.white,
                  CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(Icons.shopping_cart_rounded, '2'),
              _buildVerticalDivider(),
              _buildStatItem(Icons.payment_rounded, '4'),
              _buildVerticalDivider(),
              _buildStatItem(Icons.check_circle_rounded, '3'),
              _buildVerticalDivider(),
              _buildStatItem(Icons.cancel_rounded, '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String amount, IconData icon, Color color, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}
