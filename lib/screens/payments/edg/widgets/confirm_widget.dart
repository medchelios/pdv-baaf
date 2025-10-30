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
          ListTile(
            title: const Text('Client'),
            trailing: Text(
              customerData?['name'] ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Référence'),
            trailing: Text(
              customerReference,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
            const Divider(),
            ListTile(
              title: const Text('Téléphone'),
              trailing: Text(
                phoneNumber!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          if (customerType == 'postpaid' && selectedBillCode != null) ...[
            const Divider(),
            ListTile(
              title: const Text('Facture'),
              trailing: Text(
                selectedBillCode!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (selectedBillPeriod != null) ...[
              const Divider(),
              ListTile(
                title: const Text('Période'),
                trailing: Text(
                  selectedBillPeriod!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ] else ...[
            const Divider(),
            ListTile(
              title: const Text('Service'),
              trailing: const Text(
                'Recharge électricité',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
          const Divider(thickness: 2),
          ListTile(
            title: const Text(
              'Montant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              '${FormatUtils.formatAmount((amount ?? 0).toString())} GNF',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Retour'),
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
}
