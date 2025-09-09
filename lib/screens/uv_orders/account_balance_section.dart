import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';
import '../../utils/format_utils.dart';

class AccountBalanceSection extends StatelessWidget {
  final Map<String, dynamic> accountBalance;

  const AccountBalanceSection({super.key, required this.accountBalance});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Principal',
                  accountBalance['principal_balance']?.toString() ?? '0',
                  Icons.account_balance_wallet,
                  AppConstants.brandBlue,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildBalanceItem(
                  'Commission',
                  accountBalance['commission_balance']?.toString() ?? '0',
                  Icons.trending_up,
                  AppConstants.brandOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String amount, IconData icon, Color color) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FormatUtils.formatAmountWithSpaces(amount.replaceAll(' GNF', '').replaceAll(' ', '')),
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
          ),
        ),
        Icon(
          icon,
          color: color,
          size: 24,
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
