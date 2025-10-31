import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/payment_service.dart';
import '../../../shared/widgets/payment_details_dialog.dart';
import '../../payments/payments_screen.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await PaymentService().getPayments(page: 1, limit: 5);

      if (result != null && result['payments'] != null) {
        setState(() {
          _transactions = List<Map<String, dynamic>>.from(result['payments']);
        });
      }
    } catch (e) {
      // Erreur silencieuse
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.all(20),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions Récentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: AppConstants.brandBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text(
                  'Aucun paiement récent disponible',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ),
            )
          else
            ..._transactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildTransactionItem(
                  title: transaction['subscriber_name'] ?? 'Paiement',
                  subtitle: transaction['formatted_created_at'] ?? 'Récent',
                  amount: transaction['formatted_amount'] ?? '0 GNF',
                  reference: transaction['reference'],
                  period:
                      transaction['formatted_created_at']?.split(' ')[0] ??
                      'N/A',
                  subscriberName: transaction['subscriber_name'],
                  status: transaction['status'],
                  statusLabel: transaction['status_label'],
                  transactionData: transaction,
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    String? reference,
    String? period,
    String? subscriberName,
    String? status,
    String? statusLabel,
    Map<String, dynamic>? transactionData,
  }) {
    return GestureDetector(
      onTap: () {
        if (transactionData != null) {
          showDialog(
            context: context,
            builder: (context) =>
                PaymentDetailsDialog(paymentData: transactionData),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscriberName ?? title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  if (reference != null && reference.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Ref: $reference',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  if (period != null && period.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      period,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    statusLabel ?? subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
