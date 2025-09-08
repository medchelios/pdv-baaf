import 'package:flutter/material.dart';
import '../widgets/common/action_button.dart';
import '../constants/app_constants.dart';
import 'prepaid_payment_screen.dart';
import 'postpaid_payment_screen.dart';

class PaymentTypeScreen extends StatelessWidget {
  const PaymentTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Paiements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.paddingL),
              
              // Titre
              Text(
                'Choisissez le type de paiement',
                style: AppConstants.heading2,
              ),
              
              const SizedBox(height: AppConstants.paddingS),
              
              Text(
                'Sélectionnez le type de paiement à effectuer',
                style: AppConstants.bodyMedium,
              ),
              
              const SizedBox(height: AppConstants.paddingXXL),
              
              // Options de paiement
              Expanded(
                child: Column(
                  children: [
                    // Paiement prépayé
                    ActionButton(
                      title: 'Prépayé',
                      subtitle: 'Recharge de crédit',
                      icon: Icons.payment_rounded,
                      color: AppConstants.primaryOrange,
                      isFullWidth: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrepaidPaymentScreen(),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.paddingM),
                    
                    // Paiement postpayé
                    ActionButton(
                      title: 'Postpayé',
                      subtitle: 'Paiement de facture',
                      icon: Icons.receipt_long_rounded,
                      color: AppConstants.primaryBlue,
                      isFullWidth: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostpaidPaymentScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}