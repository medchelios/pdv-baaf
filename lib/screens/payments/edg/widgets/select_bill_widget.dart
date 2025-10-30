import 'package:flutter/material.dart';
import '../../../../utils/format_utils.dart';

class SelectBillWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? bills;
  final Function(Map<String, dynamic>) onBillSelected;
  final VoidCallback onBack;

  const SelectBillWidget({
    super.key,
    required this.bills,
    required this.onBillSelected,
    required this.onBack,
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

              return ListTile(
                title: Text(code),
                subtitle: period.isNotEmpty ? Text('Période: $period') : null,
                trailing: Text(
                  '${FormatUtils.formatAmount(amount.toString())} GNF',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () => onBillSelected(bill),
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
        ],
      ),
    );
  }
}
