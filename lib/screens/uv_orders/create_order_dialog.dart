import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';

class CreateOrderDialog extends StatefulWidget {
  final VoidCallback onOrderCreated;

  const CreateOrderDialog({super.key, required this.onOrderCreated});

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
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
      backgroundColor: Colors.white,
      title: Text(
        'Nouvelle Commande UV',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      contentPadding: const EdgeInsets.all(24),
      content: SizedBox(
        width: 350,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant (GNF)',
                  border: OutlineInputBorder(),
                  prefixText: 'GNF ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un montant';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount < 1000) {
                    return 'Le montant doit être d\'au moins 1000 GNF';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.paddingM),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Annuler', style: Theme.of(context).textTheme.bodyMedium),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createOrder,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'Créer',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
        ),
      ],
    );
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await UVOrderService().createOrder(
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        type: 'order',
      );

      if (result != null && mounted) {
        Navigator.of(context).pop();
        widget.onOrderCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande créée avec succès'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la création de la commande'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création de la commande'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
