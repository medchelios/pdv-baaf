import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class PaymentFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PaymentFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppConstants.brandBlue,
      child: const Icon(
        Icons.payment,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class PaymentOptionsModal extends StatelessWidget {
  const PaymentOptionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          const Text(
            'Nouveau Paiement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
          // Payment options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildPaymentOption(
                  context,
                  icon: Icons.electrical_services,
                  title: 'Paiement Électricité',
                  subtitle: 'Payer une facture d\'électricité',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to electricity payment
                  },
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  context,
                  icon: Icons.phone,
                  title: 'Paiement Mobile',
                  subtitle: 'Recharger un téléphone',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to mobile payment
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE9ECEF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2E7D32),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF6C757D),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
