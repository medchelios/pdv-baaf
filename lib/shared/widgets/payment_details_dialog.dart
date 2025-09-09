import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class PaymentDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const PaymentDetailsDialog({
    super.key,
    required this.paymentData,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppConstants.brandBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Détails du Paiement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations du paiement
                    _buildSection(
                      'Informations du paiement',
                      Icons.payment,
                      [
                        _buildDetailRow('Référence', paymentData['reference'] ?? 'N/A'),
                        _buildDetailRow('Statut', paymentData['status_label'] ?? 'N/A'),
                        _buildDetailRow('Méthode de paiement', paymentData['payment_method_label'] ?? 'N/A'),
                        _buildDetailRow('Montant', paymentData['formatted_amount'] ?? '0 GNF'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Informations client EDG
                    _buildSection(
                      'Informations client EDG',
                      Icons.person,
                      [
                        _buildDetailRow('Nom du client', paymentData['subscriber_name'] ?? 'N/A'),
                        _buildDetailRow('Référence client', paymentData['subscriber_reference'] ?? 'N/A'),
                        _buildDetailRow('Téléphone', paymentData['phone_number']?.toString() ?? 'N/A'),
                        _buildDetailRow('Type de client', paymentData['customer_type_label'] ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tokens EDG
                    if (paymentData['edg_display_value'] != null)
                      _buildSection(
                        'Tokens EDG',
                        Icons.qr_code,
                        [
                          _buildDetailRow(
                            paymentData['edg_display_label'] ?? 'Token',
                            paymentData['edg_display_value'],
                          ),
                          if (paymentData['edg_instructions'] != null)
                            _buildDetailRow('Instructions', paymentData['edg_instructions']),
                        ],
                      ),
                    const SizedBox(height: 20),
                    // Détails techniques
                    _buildSection(
                      'Détails techniques',
                      Icons.settings,
                      [
                        _buildDetailRow('Date de traitement', paymentData['formatted_processed_at'] ?? 'N/A'),
                        _buildDetailRow('Date de création', paymentData['formatted_created_at'] ?? 'N/A'),
                      ],
                    ),
                    // Notes
                    if (paymentData['notes'] != null && paymentData['notes'].toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSection(
                        'Notes et commentaires',
                        Icons.note,
                        [
                          _buildDetailRow('Notes', paymentData['notes']),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppConstants.brandBlue,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
