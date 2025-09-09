import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class PrepaidPaymentScreen extends StatefulWidget {
  const PrepaidPaymentScreen({super.key});

  @override
  State<PrepaidPaymentScreen> createState() => _PrepaidPaymentScreenState();
}

class _PrepaidPaymentScreenState extends State<PrepaidPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  
  String _selectedMethod = 'mobile_money';

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Paiement Prépayé',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.brandBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte d'information
              _buildInfoCard(),
              
              const SizedBox(height: 24),
              
              // Formulaire
              _buildForm(),
              
              const SizedBox(height: 32),
              
              // Bouton de paiement
              _buildPaymentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.brandOrange,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Paiement Prépayé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Achetez du crédit électrique pour vos clients',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Montant minimum: 1,000 GNF',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations du paiement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Numéro de téléphone
          _buildTextField(
            controller: _phoneController,
            label: 'Numéro de téléphone',
            hint: 'Ex: 612345678',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir le numéro de téléphone';
              }
              if (value.length < 9) {
                return 'Numéro de téléphone invalide';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Référence client
          _buildTextField(
            controller: _referenceController,
            label: 'Référence client EDG',
            hint: 'Ex: 1234567890',
            icon: Icons.receipt_rounded,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir la référence client';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Montant
          _buildTextField(
            controller: _amountController,
            label: 'Montant (GNF)',
            hint: 'Ex: 5000',
            icon: Icons.attach_money_rounded,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir le montant';
              }
              final amount = int.tryParse(value);
              if (amount == null || amount < 1000) {
                return 'Montant minimum: 1,000 GNF';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // Méthode de paiement
          const Text(
            'Méthode de paiement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildPaymentMethodOption(
            value: 'mobile_money',
            title: 'Mobile Money',
            subtitle: 'Orange Money, MTN Money',
            icon: Icons.phone_android_rounded,
          ),
          
          const SizedBox(height: 8),
          
          _buildPaymentMethodOption(
            value: 'card',
            title: 'Carte bancaire',
            subtitle: 'Visa, Mastercard',
            icon: Icons.credit_card_rounded,
          ),
          
          const SizedBox(height: 8),
          
          _buildPaymentMethodOption(
            value: 'cash',
            title: 'Espèces',
            subtitle: 'Paiement en liquide',
            icon: Icons.money_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppConstants.brandBlue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppConstants.brandBlue),
            ),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedMethod == value 
              ? AppConstants.brandBlue.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedMethod == value 
                ? AppConstants.brandBlue
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedMethod == value 
                  ? AppConstants.brandBlue
                  : AppConstants.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedMethod == value 
                          ? AppConstants.brandBlue
                          : AppConstants.textPrimary,
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
            if (_selectedMethod == value)
              const Icon(
                Icons.check_circle_rounded,
                color: AppConstants.brandBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _processPayment();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.brandOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Traiter le paiement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    // TODO: Traiter le paiement avec l'API
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paiement traité'),
        content: const Text('Le paiement prépayé a été traité avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}