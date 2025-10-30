import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sélectionner la facture',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (bills == null || bills!.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.receipt_long, size: 48, color: AppConstants.textSecondary),
                  SizedBox(height: 12),
                  Text(
                    'Aucune facture disponible',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            ...bills!.asMap().entries.map((entry) {
              final index = entry.key;
              final bill = entry.value;
              final amount = bill['amount'] ?? bill['amt'] ?? 0;
              final period = bill['period'] ?? '';
              final code = bill['code'] ?? '';

              return Container(
                margin: EdgeInsets.only(bottom: index < bills!.length - 1 ? 12 : 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppConstants.brandOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: AppConstants.brandOrange,
                    ),
                  ),
                  title: Text(
                    code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: period.isNotEmpty
                      ? Text(
                          'Période: $period',
                          style: const TextStyle(
                            color: AppConstants.textSecondary,
                            fontSize: 12,
                          ),
                        )
                      : null,
                  trailing: Text(
                    '${FormatUtils.formatAmount(amount.toString())} GNF',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.brandOrange,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => onBillSelected(bill),
                ),
              );
            }),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

