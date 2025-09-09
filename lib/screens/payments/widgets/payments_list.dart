import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../shared/widgets/payment_details_dialog.dart';

class PaymentsList extends StatelessWidget {
  final List<Map<String, dynamic>> payments;
  final bool isLoading;

  const PaymentsList({
    super.key,
    required this.payments,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // En-tête du tableau
        _buildTableHeader(),
        // Corps du tableau
        Expanded(
          child: payments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun paiement trouvé',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return _buildTableRow(context, payment, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Client',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Montant',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Statut',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Map<String, dynamic> payment, int index) {
    final isEven = index % 2 == 0;
    
    return Container(
      decoration: BoxDecoration(
        color: isEven ? Colors.white : const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => PaymentDetailsDialog(paymentData: payment),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['subscriber_name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment['payment_method_label'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    payment['formatted_amount'] ?? '0 GNF',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.brandBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(payment['status']),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          payment['status_label'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(payment['status']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    payment['formatted_created_at']?.split(' ')[0] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem(BuildContext context, Map<String, dynamic> payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => PaymentDetailsDialog(paymentData: payment),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec référence et statut
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        payment['reference'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(payment['status']).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        payment['status_label'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(payment['status']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Client et montant
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment['subscriber_name'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            payment['payment_method_label'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppConstants.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          payment['formatted_amount'] ?? '0 GNF',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.brandBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payment['formatted_created_at'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppConstants.brandBlue;
    }
  }
}