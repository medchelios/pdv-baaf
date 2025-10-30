import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../utils/format_utils.dart';

class ConfirmWidget extends StatelessWidget {
  final String? customerType;
  final Map<String, dynamic>? customerData;
  final String customerReference;
  final String? phoneNumber;
  final String? selectedBillCode;
  final String? selectedBillPeriod;
  final int? amount;
  final VoidCallback onBack;
  final VoidCallback onProcess;

  const ConfirmWidget({
    super.key,
    required this.customerType,
    required this.customerData,
    required this.customerReference,
    required this.phoneNumber,
    required this.selectedBillCode,
    required this.selectedBillPeriod,
    required this.amount,
    required this.onBack,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Confirmer le paiement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Résumé
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Résumé du paiement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSummaryRow('Client', customerData?['name'] ?? '-'),
                const Divider(),
                _buildSummaryRow('Référence', customerReference),
                if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                  const Divider(),
                  _buildSummaryRow('Téléphone', phoneNumber!),
                ],
                if (customerType == 'postpaid' && selectedBillCode != null) ...[
                  const Divider(),
                  _buildSummaryRow('Facture', selectedBillCode!),
                  if (selectedBillPeriod != null) ...[
                    const Divider(),
                    _buildSummaryRow('Période', selectedBillPeriod!),
                  ],
                ] else ...[
                  const Divider(),
                  _buildSummaryRow('Service', 'Recharge électricité'),
                ],
                const SizedBox(height: 16),
                const Divider(thickness: 2),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Montant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    Text(
                      '${FormatUtils.formatAmount((amount ?? 0).toString())} GNF',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.brandOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Boutons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Retour'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onProcess,
                  icon: const Icon(Icons.payment, size: 24),
                  label: const Text(
                    'Confirmer le paiement',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.brandOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

