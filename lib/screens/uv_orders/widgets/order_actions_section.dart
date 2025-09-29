import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/uv_order_service.dart';
import '../../../services/auth_service.dart';

class OrderActionsSection extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderActionsSection({super.key, required this.order});

  @override
  State<OrderActionsSection> createState() => _OrderActionsSectionState();
}

class _OrderActionsSectionState extends State<OrderActionsSection> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _canValidateOrder(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppConstants.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: AppConstants.brandBlue.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Aucune action disponible pour cette commande',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.brandBlue,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: [
            Text(
              'Actions disponibles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _validateOrder,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: const Text('Valider'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.successColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingM,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _rejectOrder,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.close_rounded),
                    label: const Text('Rejeter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.errorColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingM,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _canValidateOrder() async {
    return widget.order['status'] == 'pending_validation';
  }

  Future<void> _validateOrder() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _ValidateOrderDialog(order: widget.order),
    );

    if (result != true) return;

    setState(() => _isLoading = true);

    try {
      final success = await UVOrderService().validateOrder(
        orderId: widget.order['id'] as int,
        comment: 'Validé par mobile',
      );

      if (success && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande validée avec succès'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la validation'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la validation'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _rejectOrder() async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => _RejectOrderDialog(order: widget.order),
    );

    if (result == null) return;

    setState(() => _isLoading = true);

    try {
      final success = await UVOrderService().rejectOrder(
        orderId: widget.order['id'],
        comment: result['comment'] ?? '',
      );

      if (success && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande rejetée avec succès'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du rejet'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du rejet'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _ValidateOrderDialog extends StatelessWidget {
  final Map<String, dynamic> order;

  const _ValidateOrderDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmer la validation',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: AppConstants.brandBlue),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Êtes-vous sûr de vouloir valider cette commande ?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            'Montant: ${order['formatted_total_amount'] ?? '0 GNF'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppConstants.brandBlue,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'Demandé par: ${order['requester_name'] ?? 'N/A'}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Annuler',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppConstants.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.successColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            'Valider',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _RejectOrderDialog extends StatefulWidget {
  final Map<String, dynamic> order;

  const _RejectOrderDialog({required this.order});

  @override
  State<_RejectOrderDialog> createState() => _RejectOrderDialogState();
}

class _RejectOrderDialogState extends State<_RejectOrderDialog> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmer le rejet',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: AppConstants.brandBlue),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merci de préciser le motif du rejet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              'Montant: ${widget.order['formatted_total_amount'] ?? '0 GNF'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppConstants.brandBlue,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              'Demandé par: ${widget.order['requester_name'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Motif du rejet',
                hintText: 'Expliquez pourquoi vous rejetez cette commande...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  borderSide: const BorderSide(color: AppConstants.brandBlue),
                ),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le motif du rejet est obligatoire';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Annuler',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppConstants.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(
                context,
              ).pop({'comment': _commentController.text.trim()});
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.errorColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            'Rejeter',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
