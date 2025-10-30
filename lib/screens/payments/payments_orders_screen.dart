import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/payment_service.dart';
import '../../utils/format_utils.dart';
import '../home/widgets/payments_table.dart';

class PaymentsOrdersScreen extends StatefulWidget {
  const PaymentsOrdersScreen({super.key});

  @override
  State<PaymentsOrdersScreen> createState() => _PaymentsOrdersScreenState();
}

class _PaymentsOrdersScreenState extends State<PaymentsOrdersScreen> {
  List<Map<String, dynamic>> _payments = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() => _isLoading = true);
    try {
      final result = await PaymentService().getPayments(
        page: _currentPage,
        limit: _itemsPerPage,
        search: '',
      );
      if (result != null && result['payments'] != null) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(result['payments']);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _totalPayments() => _payments.length;

  int _failedPayments() {
    return _payments.where((p) {
      final status = (p['status'] ?? p['payment_status'] ?? '')
          .toString()
          .toLowerCase();
      return status == 'failed' ||
          status == 'failure' ||
          status == 'canceled' ||
          status == 'cancelled';
    }).length;
  }

  String _totalAmountFormatted() {
    final total = _payments.fold<int>(0, (sum, p) {
      final amount = p['amount'] ?? p['total_amount'] ?? p['paid_amount'] ?? 0;
      if (amount is num) return sum + amount.toInt();
      if (amount is String) {
        final normalized = amount.replaceAll(RegExp(r'[^0-9-]'), '');
        final parsed = int.tryParse(normalized) ?? 0;
        return sum + parsed;
      }
      return sum;
    });
    return FormatUtils.formatAmount(total.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paiements',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandWhite),
        ),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/payments/recent'),
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
          ),
          IconButton(
            onPressed: _loadPayments,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPayments,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _StatTile(
                              title: 'Paiements',
                              value: _totalPayments().toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _StatTile(
                              title: 'Montant total',
                              value: _totalAmountFormatted(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: _StatTile(
                              title: 'Échecs',
                              value: _failedPayments().toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: PaymentsTable(
                      payments: _payments,
                      currentPage: _currentPage,
                      itemsPerPage: _itemsPerPage,
                      onPageChanged: (page) {
                        setState(() => _currentPage = page);
                        _loadPayments();
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionMenu,
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        child: const Icon(Icons.add),
      ),
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
            const Text(
              'Types de paiement',
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
                    icon: Icons.bolt,
                    title: 'Prépayé',
                    subtitle: 'Facture électricité (prépayé)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/payments/edg',
                        arguments: {'type': 'prepaid'},
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionOption(
                    context,
                    icon: Icons.receipt_long,
                    title: 'Postpayé',
                    subtitle: 'Facture électricité (postpayé)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/payments/edg',
                        arguments: {'type': 'postpaid'},
                      );
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
                  color: AppConstants.brandBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppConstants.brandBlue, size: 24),
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

class _StatTile extends StatelessWidget {
  final String title;
  final String value;

  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
