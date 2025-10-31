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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Client'),
                      Text(
                        customerData?['name'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Référence'),
                      Text(
                        customerReference,
                        style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Téléphone'),
                        Text(
                          phoneNumber!,
                          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Référence déjà affichée dans la carte ci-dessus
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
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Montant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(
                    '${FormatUtils.formatAmount((amount ?? 0).toString())} GNF',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
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
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Retour'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: onProcess,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: const StadiumBorder()),
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
