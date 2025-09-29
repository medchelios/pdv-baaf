import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';
import '../../utils/format_utils.dart';

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
                  // Un PDV ne valide rien - il ne voit que SES commandes
                  // La validation se fait par d'autres rôles (distributor, semi_grossiste, etc.)
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
}
