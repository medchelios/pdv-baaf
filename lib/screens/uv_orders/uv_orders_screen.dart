import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';
import '../../services/logger_service.dart';
import '../../services/auth_service.dart';
import 'create_order_dialog.dart';
import 'stats_section.dart';
import 'account_balance_section.dart';
import 'recent_orders_section.dart';

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
  List<Map<String, dynamic>>? _availableActions;
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
      final recent = await _uvOrderService.getRecentOrders(limit: 10);
      final balance = await _uvOrderService.getAccountBalance();
      final actions = await _uvOrderService.getAvailableActions();

      setState(() {
        _stats = Map<String, dynamic>.from(stats ?? {});
        _accountBalance = balance;
        _recentOrders = List<Map<String, dynamic>>.from(recent ?? []);
        _availableActions = List<Map<String, dynamic>>.from(actions ?? []);
        _isLoading = false;
      });
    } catch (e) {
      LoggerService.error('Erreur lors du chargement des données', e);
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
        title: Text(
          'Commandes UV',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandWhite),
        ),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
        actions: _buildAppBarActions(),
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
                      StatsSection(stats: _stats!),
                      const SizedBox(height: AppConstants.paddingS),
                    ],

                    if (_accountBalance != null) ...[
                      AccountBalanceSection(accountBalance: _accountBalance!),
                      const SizedBox(height: AppConstants.paddingS),
                    ],

                    RecentOrdersSection(
                      recentOrders: _recentOrders,
                      onRefresh: _loadData,
                      currentUserId: AuthService().user?['id'] ?? 0,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        onPressed: _loadData,
        icon: const Icon(Icons.refresh),
        tooltip: 'Actualiser',
      ),
    ];
  }

  Widget? _buildFloatingActionButton() {
    if (_availableActions == null) return null;
    
    // Chercher l'action "create_order" en priorité
    final createOrderAction = _availableActions!.firstWhere(
      (action) => action['type'] == 'create_order',
      orElse: () => _availableActions!.firstWhere(
        (action) => action['type'] != 'refresh',
        orElse: () => {},
      ),
    );

    if (createOrderAction.isEmpty) return null;

    return FloatingActionButton(
      onPressed: () => _handleAction(createOrderAction['type']),
      child: Icon(_getIcon(createOrderAction['icon'])),
      backgroundColor: _getActionColor(createOrderAction['color']),
      foregroundColor: Colors.white,
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'add_rounded':
        return Icons.add_rounded;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'refresh':
        return Icons.refresh;
      default:
        return Icons.help;
    }
  }

  Color _getActionColor(String colorName) {
    switch (colorName) {
      case 'orange':
        return AppConstants.brandOrange;
      case 'blue':
        return AppConstants.brandBlue;
      case 'gray':
        return Colors.grey;
      default:
        return AppConstants.brandBlue;
    }
  }

  void _handleAction(String actionType) {
    switch (actionType) {
      case 'create_order':
        _showCreateOrderDialog();
        break;
      case 'recharge_account':
        _showRechargeAccountDialog();
        break;
      case 'refresh':
        _loadData();
        break;
    }
  }

  void _showRechargeAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Recharge de compte',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Fonctionnalité de recharge de compte en cours de développement.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Fermer',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateOrderDialog(onOrderCreated: _loadData),
    );
  }
}
