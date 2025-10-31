import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/payment_service.dart';

class PaymentDetailScreen extends StatefulWidget {
  final String paymentId;
  final Map<String, dynamic>? initialPayment;

  const PaymentDetailScreen({
    super.key,
    required this.paymentId,
    this.initialPayment,
  });

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  Map<String, dynamic>? _payment;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _payment = widget.initialPayment;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await PaymentService().getPaymentDetails(widget.paymentId);
    if (mounted) {
      setState(() {
        _payment = data ?? _payment;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Détails du paiement'),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        actions: [
          if (_payment != null)
            IconButton(
              tooltip: 'Reçu',
              icon: const Icon(Icons.receipt_long),
              onPressed: () async {
                final receipt = await PaymentService().getReceipt(
                  _payment!['id'].toString(),
                );
                if (!mounted) return;
                if (receipt == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reçu indisponible'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reçu de paiement'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lien de consultation:'),
                        const SizedBox(height: 4),
                        SelectableText(receipt['receipt_url']!),
                        const SizedBox(height: 12),
                        const Text('Lien de téléchargement:'),
                        const SizedBox(height: 4),
                        SelectableText(receipt['download_url']!),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _payment == null
          ? const Center(child: Text('Paiement introuvable'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section('Informations du paiement', Icons.payment, [
                    _row('Référence', _payment!['reference'] ?? 'N/A'),
                    _row('Statut', _payment!['status_label'] ?? 'N/A'),
                    _row(
                      'Méthode de paiement',
                      _payment!['payment_method_label'] ?? 'N/A',
                    ),
                    _row('Montant', _payment!['formatted_amount'] ?? '0 GNF'),
                  ]),
                  const SizedBox(height: 16),
                  _section('Informations client EDG', Icons.person, [
                    _row(
                      'Nom du client',
                      _payment!['subscriber_name'] ?? 'N/A',
                    ),
                    _row(
                      'Référence client',
                      _payment!['subscriber_reference'] ?? 'N/A',
                    ),
                    _row(
                      'Téléphone',
                      _payment!['phone_number']?.toString() ?? 'N/A',
                    ),
                    _row(
                      'Type de client',
                      _payment!['customer_type_label'] ?? 'N/A',
                    ),
                  ]),
                  if (_payment!['edg_display_value'] != null) ...[
                    const SizedBox(height: 16),
                    _section('Tokens EDG', Icons.qr_code, [
                      _row(
                        _payment!['edg_display_label'] ?? 'Token',
                        _payment!['edg_display_value'],
                      ),
                      if (_payment!['edg_instructions'] != null)
                        _row('Instructions', _payment!['edg_instructions']),
                    ]),
                  ],
                  const SizedBox(height: 16),
                  _section('Détails techniques', Icons.settings, [
                    _row(
                      'Date de traitement',
                      _payment!['formatted_processed_at'] ?? 'N/A',
                    ),
                    _row(
                      'Date de création',
                      _payment!['formatted_created_at'] ?? 'N/A',
                    ),
                  ]),
                  if (_payment!['notes'] != null &&
                      _payment!['notes'].toString().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _section('Notes et commentaires', Icons.note, [
                      _row('Notes', _payment!['notes']),
                    ]),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.brandBlue),
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

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
