import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';

class AccountBalanceSection extends StatelessWidget {
  final Map<String, dynamic> accountBalance;

  const AccountBalanceSection({super.key, required this.accountBalance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mes comptes',
          style: AppConstants.heading2.copyWith(
            color: AppConstants.brandBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        CustomCard(
          child: Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Principal',
                  accountBalance['formatted_principal_balance'] ?? '0 GNF',
                  Icons.account_balance_wallet,
                  AppConstants.brandBlue,
                  CrossAxisAlignment.start,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildBalanceItem(
                  'Commission',
                  accountBalance['formatted_commission_balance'] ?? '0 GNF',
                  Icons.trending_up,
                  AppConstants.brandOrange,
                  CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceItem(String label, String amount, IconData icon, Color color, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: AppConstants.heading3.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppConstants.bodySmall.copyWith(
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
