import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/uv_order_service.dart';
import '../../services/logger_service.dart';
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

      setState(() {
        _stats = Map<String, dynamic>.from(stats ?? {});
        _accountBalance = balance;
        _recentOrders = List<Map<String, dynamic>>.from(recent ?? []);
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
    return FloatingActionButton.small(
      onPressed: _showActionMenu,
      backgroundColor: AppConstants.brandOrange,
      foregroundColor: AppConstants.brandWhite,
      child: const Icon(Icons.add),
    );
  }

  void _showActionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Actions UV',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildActionOption(
                    context,
                    icon: Icons.add_rounded,
                    title: 'Créer une commande',
                    subtitle: 'Nouvelle commande UV',
                    onTap: () {
                      Navigator.pop(context);
                      _showCreateOrderDialog();
                    },
                  ),
                  _buildActionOption(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: 'Recharger le compte',
                    subtitle: 'Demande de recharge',
                    onTap: () {
                      Navigator.pop(context);
                      _showRechargeAccountDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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

  Widget _buildActionOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.brandOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppConstants.brandOrange, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF6C757D),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
