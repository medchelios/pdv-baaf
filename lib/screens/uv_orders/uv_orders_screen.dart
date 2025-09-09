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
      LoggerService.info('Début du chargement des données UV');
      final stats = await _uvOrderService.getStats();
      LoggerService.info('Stats chargées: $stats');
      
      final balance = await _uvOrderService.getAccountBalance();
      LoggerService.info('Balance chargée: $balance');
      
      final orders = await _uvOrderService.getRecentOrders();
      LoggerService.info('Commandes chargées: ${orders?.length} éléments');

      setState(() {
        _stats = stats;
        _accountBalance = balance;
        _recentOrders = orders;
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
                      StatsSection(stats: _stats!),
                      const SizedBox(height: AppConstants.paddingXL),
                    ],
                    
                    if (_accountBalance != null) ...[
                      AccountBalanceSection(accountBalance: _accountBalance!),
                      const SizedBox(height: AppConstants.paddingXL),
                    ],
                    
                    RecentOrdersSection(
                      recentOrders: _recentOrders,
                      onRefresh: _loadData,
                    ),
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

  void _showCreateOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateOrderDialog(
        onOrderCreated: _loadData,
      ),
    );
  }
}
