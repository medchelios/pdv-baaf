import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';
import '../../services/auth_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails de la commande',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandBlue),
        ),
        backgroundColor: AppConstants.brandWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.brandBlue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: AppConstants.paddingL),
            _buildOrderDetails(),
            const SizedBox(height: AppConstants.paddingL),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.brandWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.brandBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.brandBlue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de la commande',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppConstants.brandBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildInfoRow('Type', widget.order['type_label'] ?? 'Commande UV'),
          _buildInfoRow('Montant', widget.order['formatted_amount'] ?? '0 GNF'),
          _buildInfoRow(
            'Commission',
            widget.order['bonus_amount'] != null
                ? '${widget.order['bonus_amount']} GNF'
                : '0 GNF',
          ),
          _buildInfoRow(
            'Total avec commission',
            widget.order['formatted_total_amount'] ?? '0 GNF',
          ),
          _buildInfoRow('Statut', widget.order['status_label'] ?? 'Inconnu'),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.brandWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.brandBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.brandBlue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails supplémentaires',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppConstants.brandBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildInfoRow(
            'Description',
            widget.order['description'] ?? 'Aucune description',
          ),
          _buildInfoRow('Demandé par', widget.order['requester_name'] ?? 'N/A'),
          _buildInfoRow('Date de demande', widget.order['requested_at'] ?? ''),
          if (widget.order['validated_at'] != null)
            _buildInfoRow('Date de validation', widget.order['validated_at']),
          if (widget.order['rejected_at'] != null)
            _buildInfoRow('Date de rejet', widget.order['rejected_at']),
          _buildInfoRow(
            'Validateur',
            widget.order['validator_name'] ?? 'Non assigné',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppConstants.brandBlue),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
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
    final user = AuthService().user;
    if (user == null) {
      print('DEBUG: User is null');
      return false;
    }

    print('DEBUG: User role: ${user['role']}');
    print('DEBUG: Order status: ${widget.order['status']}');
    print('DEBUG: Order requester_id: ${widget.order['requester_id']}');
    print('DEBUG: Current user id: ${user['id']}');

    // Vérifier si c'est une commande en attente de validation
    if (widget.order['status'] != 'pending_validation') {
      print('DEBUG: Order not pending validation');
      return false;
    }

    // Vérifier que ce n'est pas sa propre commande
    final currentUserId = user['id'] as int?;
    if (currentUserId == null) {
      print('DEBUG: Current user id is null');
      return false;
    }
    if (widget.order['requester_id'] == currentUserId) {
      print('DEBUG: Cannot validate own order');
      return false;
    }

    // Vérifier les rôles qui peuvent valider
    final userRole = user['role'] as String?;
    if (userRole == null) {
      print('DEBUG: User role is null');
      return false;
    }

    final canValidateRoles = [
      'distributor',
      'semi_grossiste',
      'super_admin',
      'admin',
      'baaf_user',
    ];

    final canValidate = canValidateRoles.contains(userRole);
    print('DEBUG: Can validate: $canValidate');
    return canValidate;
  }

  Future<void> _validateOrder() async {
    setState(() => _isLoading = true);

    try {
      print('DEBUG: Attempting to validate order ${widget.order['id']}');
      final success = await UVOrderService().validateOrder(
        orderId: widget.order['id'] as int,
        comment: 'Validé par mobile',
      );

      print('DEBUG: Validation result: $success');

      if (success && mounted) {
        Navigator.of(
          context,
        ).pop(true); // Retourner true pour indiquer le succès
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
      print('DEBUG: Validation error: $e');
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
    setState(() => _isLoading = true);

    try {
      // TODO: Implémenter l'API de rejet
      // final success = await UVOrderService().rejectOrder(
      //   orderId: widget.order['id'] as int,
      //   comment: 'Rejeté par mobile',
      // );

      // Pour l'instant, on simule le rejet
      if (mounted) {
        Navigator.of(
          context,
        ).pop(true); // Retourner true pour indiquer le succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande rejetée avec succès'),
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
