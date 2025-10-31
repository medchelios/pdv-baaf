import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../constants/app_constants.dart';
import '../../services/payment_service.dart';
import '../../widgets/common/custom_card.dart';

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
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _payment == null
          ? const Center(child: Text('Paiement introuvable'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingM),
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
                  const SizedBox(height: AppConstants.paddingS),
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
                  if (_payment!['customer_type'] == 'prepaid' &&
                      _payment!['edg_display_value'] != null) ...[
                    const SizedBox(height: AppConstants.paddingS),
                    _section('Tokens EDG', Icons.qr_code, [
                      _row(
                        _payment!['edg_display_label'] ?? 'Token',
                        _payment!['edg_display_value'],
                      ),
                    ]),
                  ],
                  const SizedBox(height: AppConstants.paddingS),
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
                  const SizedBox(height: AppConstants.paddingS),
                  _buildActionsSection(),
                ],
              ),
            ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.brandBlue, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.brandBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
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

  Widget _buildActionsSection() {
    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.share, color: AppConstants.brandBlue, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.brandBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onPressed: _shareViaWhatsApp,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: AppConstants.brandOrange,
                  onPressed: _shareViaEmail,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.download,
                  label: 'Télécharger',
                  color: AppConstants.brandBlue,
                  onPressed: _downloadReceipt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _shareViaWhatsApp() async {
    if (_payment == null) return;

    if (!mounted) return;
    final ctx = context;

    try {
      final receipt = await PaymentService().getReceipt(
        _payment!['id'].toString(),
      );
      if (!mounted) return;

      if (receipt == null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Reçu indisponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final message =
          'Voici votre reçu de paiement EDG\n'
          'Référence: ${_payment!['reference']}\n'
          'Montant: ${_payment!['formatted_amount']}\n'
          'Consulter: ${receipt['receipt_url']}';

      final whatsappUrl = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(message)}',
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareViaEmail() async {
    if (_payment == null) return;

    if (!mounted) return;
    final ctx = context;

    try {
      final receipt = await PaymentService().getReceipt(
        _payment!['id'].toString(),
      );
      if (!mounted) return;

      if (receipt == null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Reçu indisponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final subject = 'Reçu de paiement EDG - ${_payment!['reference']}';
      final body =
          'Bonjour,\n\n'
          'Voici votre reçu de paiement EDG.\n\n'
          'Détails du paiement:\n'
          '- Référence: ${_payment!['reference']}\n'
          '- Montant: ${_payment!['formatted_amount']}\n'
          '- Date: ${_payment!['formatted_created_at']}\n\n'
          'Consulter le reçu: ${receipt['receipt_url']}\n'
          'Télécharger le reçu: ${receipt['download_url']}\n\n'
          'Cordialement,\n'
          'Service BAAF';

      await Share.share(body, subject: subject);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadReceipt() async {
    if (_payment == null) return;

    if (!mounted) return;
    final ctx = context;

    try {
      final receipt = await PaymentService().getReceipt(
        _payment!['id'].toString(),
      );
      if (!mounted) return;

      if (receipt == null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Reçu indisponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final downloadUrl = Uri.parse(receipt['download_url']!);

      if (await canLaunchUrl(downloadUrl)) {
        await launchUrl(downloadUrl, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le lien de téléchargement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
