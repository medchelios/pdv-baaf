import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';
import '../../services/logger_service.dart';

class RechargeAccountDialog extends StatefulWidget {
  final VoidCallback onRechargeRequested;

  const RechargeAccountDialog({super.key, required this.onRechargeRequested});

  @override
  State<RechargeAccountDialog> createState() => _RechargeAccountDialogState();
}

class _RechargeAccountDialogState extends State<RechargeAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Demande de recharge à BAAF',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Annuler', style: Theme.of(context).textTheme.bodyMedium),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitRechargeRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.brandOrange,
            foregroundColor: AppConstants.brandWhite,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Envoyer la demande'),
        ),
      ],
      contentPadding: const EdgeInsets.all(24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cette action enverra une demande de recharge de votre compte à BAAF.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsSeparatorInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Montant demandé (GNF)',
                  hintText: 'Ex: 50000',
                  helperText: 'Montant minimum: 1 000 GNF',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le montant est requis';
                  }
                  final amount = int.tryParse(value.replaceAll(' ', ''));
                  if (amount == null || amount < 1000) {
                    return 'Le montant minimum est de 1 000 GNF';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description de la demande',
                  hintText:
                      'Ex: Demande de recharge pour couvrir les besoins du réseau',
                  helperText:
                      'Expliquez la raison de cette demande de recharge',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La description est requise';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRechargeRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text.replaceAll(' ', ''));
      final description = _descriptionController.text.trim();

      LoggerService.info('Création d\'une demande de recharge: $amount GNF');

      final result = await UVOrderService().createRechargeRequest(
        amount: amount,
        description: description,
      );

      if (mounted) {
        if (result != null) {
          Navigator.of(context).pop();
          widget.onRechargeRequested();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Demande de recharge envoyée avec succès',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          _showError('Impossible de créer la demande de recharge');
        }
      }
    } catch (e) {
      LoggerService.error(
        'Erreur lors de la création de la demande de recharge',
        e,
      );
      if (mounted) {
        _showError('Erreur: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(' ', '');
    final number = int.tryParse(cleanText);

    if (number == null) {
      return oldValue;
    }

    final formatted = _formatNumber(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumber(int number) {
    final String numberStr = number.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < numberStr.length; i++) {
      if (i > 0 && (numberStr.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(numberStr[i]);
    }

    return buffer.toString();
  }
}
