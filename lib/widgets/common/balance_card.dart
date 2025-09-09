import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Widget>? actions;

  const BalanceCard({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.primaryColor = AppConstants.brandBlue,
    this.secondaryColor = AppConstants.brandOrange,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: AppConstants.cardShadowLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.paddingS),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
          if (actions != null) ...[
            const SizedBox(height: AppConstants.paddingXL),
            Row(
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }
}
