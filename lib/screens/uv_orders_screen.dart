import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/uv_order_service.dart';
import '../widgets/common/custom_card.dart';
import '../widgets/common/action_button.dart';

class UVOrdersScreen extends StatefulWidget {
  const UVOrdersScreen({super.key});

  @override
  State<UVOrdersScreen> createState() => _UVOrdersScreenState();
}

class _UVOrdersScreenState extends State<UVOrdersScreen> {
  final UVOrderService _uvOrderService = UVOrderService();
  Map<String, dynamic>? _stats;
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
      final orders = await _uvOrderService.getRecentOrders();

      setState(() {
        _stats = stats;
        _recentOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
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
                    if (_stats != null) _buildStatsSection(),
                    
                    const SizedBox(height: AppConstants.paddingL),
                    
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
                ),
              ),
              TextButton(
                onPressed: _loadData,
                child: const Text('Actualiser'),
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentOrders!.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppConstants.paddingS),
              itemBuilder: (context, index) {
                final order = _recentOrders![index];
                return _buildOrderItem(order);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final statusColor = _getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.textLight.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['type_label'] ?? 'Commande UV',
                style: AppConstants.bodyLarge.copyWith(
                  color: AppConstants.brandBlue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingS,
                  vertical: AppConstants.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  order['status_label'] ?? 'Inconnu',
                  style: AppConstants.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingS),
          
          Text(
            order['formatted_total_amount'] ?? '0 GNF',
            style: AppConstants.heading3.copyWith(
              color: AppConstants.textPrimary,
            ),
          ),
          
          if (order['description'] != null && order['description'].isNotEmpty) ...[
            const SizedBox(height: AppConstants.paddingXS),
            Text(
              order['description'],
              style: AppConstants.bodySmall.copyWith(
                color: AppConstants.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const SizedBox(height: AppConstants.paddingS),
          
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 14,
                color: AppConstants.textLight,
              ),
              const SizedBox(width: AppConstants.paddingXS),
              Text(
                order['requester_name'] ?? 'N/A',
                style: AppConstants.caption.copyWith(
                  color: AppConstants.textLight,
                ),
              ),
              const Spacer(),
              Text(
                order['requested_at'] ?? '',
                style: AppConstants.caption.copyWith(
                  color: AppConstants.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending_validation':
        return AppConstants.warningColor;
      case 'validated':
        return AppConstants.successColor;
      case 'rejected_by_validator':
      case 'rejected_by_admin':
        return AppConstants.errorColor;
      default:
        return AppConstants.textLight;
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
