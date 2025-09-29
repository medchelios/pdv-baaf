import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/uv_order_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/auth_service.dart';
import 'orders_table.dart';
import '../order_details_screen.dart';

class OrdersTabsSection extends StatefulWidget {
  final VoidCallback? onRefresh;

  const OrdersTabsSection({super.key, this.onRefresh});

  @override
  State<OrdersTabsSection> createState() => _OrdersTabsSectionState();
}

class _OrdersTabsSectionState extends State<OrdersTabsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UVOrderService _uvOrderService = UVOrderService();
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>>? _recentOrders;
  List<Map<String, dynamic>>? _rechargeRequests;
  bool _isLoadingRecent = true;
  bool _isLoadingRecharge = true;

  bool get _isPdvAgent => _authService.isPdvAgent;
  int get _tabCount => _isPdvAgent ? 1 : 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_isPdvAgent) {
      await _loadRecentOrders();
    } else {
      await Future.wait([_loadRecentOrders(), _loadRechargeRequests()]);
    }
  }

  Future<void> _loadRecentOrders() async {
    setState(() {
      _isLoadingRecent = true;
    });

    try {
      final orders = _isPdvAgent
          ? await _uvOrderService.getHistory(limit: 20)
          : await _uvOrderService.getRecentOrders(limit: 10);

      setState(() {
        _recentOrders = orders;
        _isLoadingRecent = false;
      });
    } catch (e) {
      LoggerService.error('Erreur lors du chargement des commandes', e);
      setState(() {
        _isLoadingRecent = false;
      });
    }
  }

  Future<void> _loadRechargeRequests() async {
    setState(() {
      _isLoadingRecharge = true;
    });

    try {
      final requests = await _uvOrderService.getRechargeRequests(limit: 10);
      final pendingRequests = requests
          ?.where((request) => request['status'] == 'pending_validation')
          .toList();

      setState(() {
        _rechargeRequests = pendingRequests;
        _isLoadingRecharge = false;
      });
    } catch (e) {
      LoggerService.error(
        'Erreur lors du chargement des demandes de rechargement',
        e,
      );
      setState(() {
        _isLoadingRecharge = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (!_isPdvAgent) ...[
            TabBar(
              controller: _tabController,
              labelColor: AppConstants.brandBlue,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppConstants.brandBlue,
              tabs: const [
                Tab(text: 'Commandes'),
                Tab(text: 'Demandes'),
              ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecentOrdersTab(),
                  _buildRechargeRequestsTab(),
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: AppConstants.brandBlue.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusM),
                  topRight: Radius.circular(AppConstants.radiusM),
                ),
              ),
              child: Text(
                'Commandes UV',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.brandBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 400, child: _buildRecentOrdersTab()),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentOrdersTab() {
    if (_isLoadingRecent) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recentOrders == null || _recentOrders!.isEmpty) {
      return Center(
        child: Text(
          _isPdvAgent ? 'Aucune commande' : 'Aucune commande récente',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      );
    }

    return OrdersTable(orders: _recentOrders!, onOrderTap: _onOrderTap);
  }

  Widget _buildRechargeRequestsTab() {
    if (_isLoadingRecharge) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_rechargeRequests == null || _rechargeRequests!.isEmpty) {
      return Center(
        child: Text(
          'Aucune demande de rechargement en attente',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      );
    }

    return OrdersTable(orders: _rechargeRequests!, onOrderTap: _onOrderTap);
  }

  void _onOrderTap(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
  }
}
