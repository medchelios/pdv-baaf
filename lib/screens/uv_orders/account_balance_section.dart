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
              children: [
                Expanded(
                  child: _buildBalanceItem(
                    context,
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
                    context,
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
        ),
      ],
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    String amount,
    IconData icon,
    Color color,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      height: 30,
      width: 1,
      decoration: BoxDecoration(
        color: AppConstants.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
}
