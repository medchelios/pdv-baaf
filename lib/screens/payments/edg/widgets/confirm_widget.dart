import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Confirmer le paiement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${FormatUtils.formatAmount((amount ?? 0).toString())} GNF',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Retour'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onProcess,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Confirmer le paiement'),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
