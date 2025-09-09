import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                'GNF',
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
          const SizedBox(height: 16),
          const Text(
            '1,500,000',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(Icons.trending_up_rounded, '+25,000'),
              _buildVerticalDivider(),
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
