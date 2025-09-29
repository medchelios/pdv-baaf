import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';
import '../../utils/format_utils.dart';
import '../../services/uv_order_data_service.dart';
import '../../services/uv_order_service.dart';
import '../../services/auth_service.dart';

class RecentOrdersSection extends StatefulWidget {
  final List<Map<String, dynamic>>? recentOrders;
  final VoidCallback onRefresh;
  final int currentUserId;

  const RecentOrdersSection({
    super.key,
    required this.recentOrders,
    required this.onRefresh,
    required this.currentUserId,
  });

  @override
  State<RecentOrdersSection> createState() => _RecentOrdersSectionState();
}

class _RecentOrdersSectionState extends State<RecentOrdersSection> {
  int _currentPage = 0;
  static const int _itemsPerPage = 3;

  @override
  Widget build(BuildContext context) {
    final orders = widget.recentOrders ?? [];
    final totalPages = (orders.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, orders.length);
    final currentOrders = orders.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Commandes Récentes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: widget.onRefresh,
              icon: Icon(Icons.refresh, color: AppConstants.brandBlue),
              tooltip: 'Actualiser',
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingS),

        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.paddingXL),
                    child: Text('Aucune commande récente'),
                  ),
                )
              else ...[
                _buildOrdersTable(context, currentOrders),
                if (totalPages > 1) ...[
                  const SizedBox(height: AppConstants.paddingM),
                  _buildPagination(totalPages),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersTable(
    BuildContext context,
    List<Map<String, dynamic>> orders,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.brandWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.brandBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // En-tête du tableau
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppConstants.brandBlue.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusM),
                topRight: Radius.circular(AppConstants.radiusM),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Montant',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Statut',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lignes du tableau
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isLast = index == orders.length - 1;

            return Container(
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: AppConstants.brandBlue.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
              ),
              child: _buildTableRow(context, order, isLast),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    Map<String, dynamic> order,
    bool isLast,
  ) {
    return InkWell(
      onTap: () => _showOrderDetails(context, order),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingS,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                order['formatted_total_amount'] ?? '0 GNF',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                FormatUtils.formatDate(order['requested_at'] ?? ''),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          order['status'] as String,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor(
                            order['status'] as String,
                          ).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        order['status_label'] ?? 'Inconnu',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(order['status'] as String),
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<bool>(
                    future: _canValidateOrder(order),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return Row(
                          children: [
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _validateOrder(context, order),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppConstants.successColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.successColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          '${_currentPage + 1} / $totalPages',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppConstants.brandBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: _currentPage < totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.brandWhite,
        title: Text(
          'Détails de la commande',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandBlue),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', order['type_label'] ?? 'Commande UV'),
              _buildDetailRow('Montant', order['formatted_amount'] ?? '0 GNF'),
              _buildDetailRow(
                'Commission',
                order['bonus_amount'] != null
                    ? '${order['bonus_amount']} GNF'
                    : '0 GNF',
              ),
              _buildDetailRow(
                'Total avec commission',
                order['formatted_total_amount'] ?? '0 GNF',
              ),
              _buildDetailRow('Statut', order['status_label'] ?? 'Inconnu'),
              _buildDetailRow(
                'Description',
                order['description'] ?? 'Aucune description',
              ),
              _buildDetailRow('Demandé par', order['requester_name'] ?? 'N/A'),
              _buildDetailRow('Date de demande', order['requested_at'] ?? ''),
              if (order['validated_at'] != null)
                _buildDetailRow('Date de validation', order['validated_at']),
              if (order['rejected_at'] != null)
                _buildDetailRow('Date de rejet', order['rejected_at']),
              _buildDetailRow(
                'Validateur',
                order['validator_name'] ?? 'Non assigné',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Fermer',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppConstants.brandBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'validated':
        return AppConstants.successColor;
      case 'pending_validation':
        return AppConstants.warningColor;
      case 'rejected_by_validator':
      case 'rejected_by_admin':
        return AppConstants.errorColor;
      default:
        return AppConstants.brandBlue;
    }
  }

  Future<bool> _canValidateOrder(Map<String, dynamic> order) async {
    final dataService = UVOrderDataService();

    // Vérifier si l'utilisateur peut valider des commandes
    if (!await dataService.canValidateOrders()) return false;

    // Vérifier si c'est une commande en attente de validation
    if (order['status'] != 'pending_validation') return false;

    // Vérifier que ce n'est pas sa propre commande
    final currentUserId = AuthService().user?['id'] as int?;
    if (currentUserId == null) return false;
    if (order['requester_id'] == currentUserId) return false;

    return true;
  }

  Future<void> _validateOrder(
    BuildContext context,
    Map<String, dynamic> order,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Valider la commande',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Voulez-vous valider cette commande de ${order['formatted_total_amount'] ?? '0 GNF'} ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Annuler',
              style: Theme.of(context).textTheme.bodyMedium,
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
      ),
    );

    if (result == true) {
      try {
        final success = await UVOrderService().validateOrder(
          orderId: order['id'] as int,
          comment: 'Validé par mobile',
        );

        if (success) {
          widget.onRefresh();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Commande validée avec succès'),
                backgroundColor: AppConstants.successColor,
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erreur lors de la validation'),
                backgroundColor: AppConstants.errorColor,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la validation'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    }
  }
}
