import 'package:flutter/material.dart';
import '../../../../services/edg_validator.dart';
import '../../../../utils/format_utils.dart';

class SelectBillWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? bills;
  final Map<String, dynamic>? selectedBill;
  final String? phoneNumber;
  final int? customAmount;
  final Function(Map<String, dynamic>) onBillSelected;
  final Function(String) onPhoneChanged;
  final Function(int?) onCustomAmountChanged;
  final VoidCallback onFullPayment;
  final VoidCallback onPartialPayment;
  final VoidCallback onBack;

  const SelectBillWidget({
    super.key,
    required this.bills,
    required this.selectedBill,
    required this.phoneNumber,
    required this.customAmount,
    required this.onBillSelected,
    required this.onPhoneChanged,
    required this.onCustomAmountChanged,
    required this.onFullPayment,
    required this.onPartialPayment,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (selectedBill == null) ...[
            // Liste des factures
            const SizedBox(height: 32),
            const Text(
              'Sélectionner la facture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (bills == null || bills!.isEmpty)
              const Text(
                'Aucune facture disponible',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              )
            else
              ...bills!.map((bill) {
                final amount = bill['amount'] ?? bill['amt'] ?? 0;
                final period = bill['period'] ?? '';
                final code = bill['code'] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text('Facture $code'),
                    subtitle: period.isNotEmpty ? Text('Période: $period') : null,
                    trailing: Text(
                      '${FormatUtils.formatAmount(amount.toString())} GNF',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => onBillSelected(bill),
                  ),
                );
              }),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBack,
                child: const Text('Retour'),
              ),
            ),
          ] else ...[
            // Options de paiement après sélection (comme backend PHP)
            const SizedBox(height: 32),
            Text(
              'Facture ${selectedBill!['code']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${FormatUtils.formatAmount((selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0).toString())} GNF',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Téléphone
            TextField(
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone *',
                border: const OutlineInputBorder(),
                errorText: EdgValidator.validatePhone(phoneNumber),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 20,
              style: const TextStyle(
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
              onChanged: onPhoneChanged,
            ),
            const SizedBox(height: 32),
            // Paiement complet
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onFullPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Paiement complet: ${FormatUtils.formatAmount((selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0).toString())} GNF',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Paiement partiel
            const Text(
              'Paiement partiel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Montant en GNF',
                border: const OutlineInputBorder(),
                errorText: customAmount != null &&
                        (customAmount! <= 0 ||
                            customAmount! >
                                (selectedBill!['amount'] ??
                                    selectedBill!['amt'] ??
                                    0))
                    ? 'Montant invalide'
                    : null,
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => onCustomAmountChanged(int.tryParse(v)),
            ),
            if (customAmount != null &&
                customAmount! >= 1000 &&
                customAmount! <=
                    (selectedBill!['amount'] ??
                        selectedBill!['amt'] ??
                        0)) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPartialPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Payer ${FormatUtils.formatAmount(customAmount.toString())} GNF',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBack,
                child: const Text('Retour'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
