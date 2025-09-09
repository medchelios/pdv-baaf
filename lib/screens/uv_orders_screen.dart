import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/uv_order_service.dart';
import '../widgets/common/custom_card.dart';

class UVOrdersScreen extends StatefulWidget {
  const UVOrdersScreen({super.key});

  @override
  State<UVOrdersScreen> createState() => _UVOrdersScreenState();
}

class _UVOrdersScreenState extends State<UVOrdersScreen> {
  final UVOrderService _uvOrderService = UVOrderService();
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _accountBalance;
  List<Map<String, dynamic>>? _recentOrders;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _uvOrderService.getStats();
      final balance = await _uvOrderService.getAccountBalance();
      final orders = await _uvOrderService.getRecentOrders();

      setState(() {
        _stats = stats;
        _accountBalance = balance;
        _recentOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Commandes UV'),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_stats != null) ...[
                      Text(
                        'Statistiques UV',
                        style: AppConstants.heading1.copyWith(
                          color: AppConstants.brandBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingM),
                      _buildStatsSection(),
                      const SizedBox(height: AppConstants.paddingXL),
                    ],
                    
                    _buildAccountBalanceSection(),
                    
                    const SizedBox(height: AppConstants.paddingXL),
                    
                    _buildRecentOrdersSection(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOrderDialog,
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildStatsSection() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallStatItem(
              'Total',
              '${_stats!['total_orders'] ?? 0}',
              AppConstants.brandBlue,
              Icons.shopping_cart_rounded,
            ),
            _buildVerticalDivider(),
            _buildSmallStatItem(
              'En attente',
              '${_stats!['pending_orders'] ?? 0}',
              AppConstants.warningColor,
              Icons.pending_rounded,
            ),
            _buildVerticalDivider(),
            _buildSmallStatItem(
              'Validées',
              '${_stats!['validated_orders'] ?? 0}',
              AppConstants.successColor,
              Icons.check_circle_rounded,
            ),
            _buildVerticalDivider(),
            _buildSmallStatItem(
              'Rejetées',
              '${_stats!['rejected_orders'] ?? 0}',
              AppConstants.errorColor,
              Icons.cancel_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXS),
          Text(
            label,
            style: AppConstants.bodySmall.copyWith(
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 35,
      width: 1,
      decoration: BoxDecoration(
        color: AppConstants.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }


  Widget _buildAccountBalanceSection() {
    if (_accountBalance == null) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Principal',
                  _accountBalance!['principal_balance']?.toString() ?? '0',
                  Icons.account_balance_wallet,
                  AppConstants.brandBlue,
                ),
              ),
              _buildVerticalDivider(),
              Expanded(
                child: _buildBalanceItem(
                  'Commission',
                  _accountBalance!['commission_balance']?.toString() ?? '0',
                  Icons.trending_up,
                  AppConstants.brandOrange,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String amount, IconData icon, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: AppConstants.heading3.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppConstants.bodySmall.copyWith(
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrdersSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Commandes Récentes',
                style: AppConstants.heading2.copyWith(
                  color: AppConstants.brandBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _loadData,
                icon: Icon(
                  Icons.refresh,
                  color: AppConstants.brandBlue,
                ),
                tooltip: 'Actualiser',
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          if (_recentOrders == null || _recentOrders!.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingXL),
                child: Text('Aucune commande récente'),
              ),
            )
          else
            _buildOrdersTable(),
        ],
      ),
    );
  }

  Widget _buildOrdersTable() {
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
                    style: AppConstants.bodyMedium.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: AppConstants.bodyMedium.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Statut',
                    style: AppConstants.bodyMedium.copyWith(
                      color: AppConstants.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lignes du tableau
          ..._recentOrders!.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isLast = index == _recentOrders!.length - 1;
            
            return Container(
              decoration: BoxDecoration(
                border: isLast ? null : Border(
                  bottom: BorderSide(
                    color: AppConstants.brandBlue.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: _buildTableRow(order, isLast),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> order, bool isLast) {
    final status = order['status'] as String;
    final statusColor = _getStatusColor(status);
    
    return InkWell(
      onTap: () => _showOrderDetails(order),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                _formatAmount(order['formatted_total_amount'] ?? '0 GNF'),
                style: AppConstants.bodyMedium.copyWith(
                  color: AppConstants.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _formatDate(order['requested_at'] ?? ''),
                style: AppConstants.bodySmall.copyWith(
                  color: AppConstants.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                order['status_label'] ?? 'Inconnu',
                style: AppConstants.bodySmall.copyWith(
                  color: _getStatusColor(order['status'] as String),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.brandWhite,
        title: Text(
          'Détails de la commande',
          style: AppConstants.heading2.copyWith(
            color: AppConstants.brandBlue,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', order['type_label'] ?? 'Commande UV'),
              _buildDetailRow('Montant', order['formatted_total_amount'] ?? '0 GNF'),
              _buildDetailRow('Statut', order['status_label'] ?? 'Inconnu'),
              _buildDetailRow('Description', order['description'] ?? 'Aucune description'),
              _buildDetailRow('Demandé par', order['requester_name'] ?? 'N/A'),
              _buildDetailRow('Date de demande', order['requested_at'] ?? ''),
              if (order['validated_at'] != null)
                _buildDetailRow('Date de validation', order['validated_at']),
              if (order['rejected_at'] != null)
                _buildDetailRow('Date de rejet', order['rejected_at']),
              _buildDetailRow('Validateur', order['validator_name'] ?? 'Non assigné'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Fermer',
              style: AppConstants.bodyMedium.copyWith(
                color: AppConstants.brandBlue,
              ),
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
              style: AppConstants.bodyMedium.copyWith(
                color: AppConstants.brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppConstants.bodyMedium.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    // Supprimer "GNF", espaces et décimales
    String cleanAmount = amount.replaceAll(' GNF', '').replaceAll(' ', '');
    // Supprimer les décimales (.00)
    if (cleanAmount.contains('.')) {
      cleanAmount = cleanAmount.split('.')[0];
    }
    return cleanAmount;
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    
    try {
      // Convertir la date du format "DD/MM/YYYY HH:MM" vers "DD/MM/YYYY"
      final parts = date.split(' ');
      return parts.isNotEmpty ? parts[0] : date;
    } catch (e) {
      return date;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'validated':
        return AppConstants.brandOrange;
      case 'pending_validation':
      case 'rejected_by_validator':
      case 'rejected_by_admin':
      default:
        return AppConstants.brandBlue;
    }
  }

  void _showCreateOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => _CreateOrderDialog(
        onOrderCreated: _loadData,
      ),
    );
  }

}

class _CreateOrderDialog extends StatefulWidget {
  final VoidCallback onOrderCreated;

  const _CreateOrderDialog({required this.onOrderCreated});

  @override
  State<_CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<_CreateOrderDialog> {
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
      title: const Text(
        'Nouvelle Commande UV',
        style: TextStyle(fontSize: 18),
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
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createOrder,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Créer'),
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
        type: 'order_uv',
      );

      if (result != null) {
        Navigator.of(context).pop();
        widget.onOrderCreated();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Commande créée avec succès'),
              backgroundColor: AppConstants.successColor,
            ),
          );
        }
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
