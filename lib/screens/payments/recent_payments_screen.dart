import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/payment_service.dart';

class RecentPaymentsScreen extends StatefulWidget {
  const RecentPaymentsScreen({super.key});

  @override
  State<RecentPaymentsScreen> createState() => _RecentPaymentsScreenState();
}

class _RecentPaymentsScreenState extends State<RecentPaymentsScreen> {
  final PaymentService _paymentService = PaymentService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _payments = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
    });

    final data = await _paymentService.getRecentPayments(limit: 20);

    if (!mounted) return;

    setState(() {
      _payments = data ?? const [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements récents'),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                itemCount: _payments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final p = _payments[index];
                  final amount = p['amount'] ?? 0;
                  final customer = p['customer_name'] ?? p['customer'] ?? '-';
                  final method = p['method'] ?? p['channel'] ?? '';
                  final status = p['status'] ?? '';
                  final createdAt = p['created_at'] ?? p['date'] ?? '';

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.brandWhite,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      border: Border.all(
                        color: AppConstants.brandBlue.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppConstants.brandBlue.withValues(alpha: 0.1),
                          child: const Icon(Icons.receipt_long, color: Color(0xFF1A73E8)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$amount GNF',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text('$customer · $method',
                                  style: TextStyle(color: Colors.grey[700])),
                              const SizedBox(height: 2),
                              Text('$createdAt', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                        ),
                        _StatusPill(status: status),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  Color _bg() {
    switch (status) {
      case 'completed':
      case 'paid':
      case 'success':
        return const Color(0xFFE6F4EA);
      case 'failed':
      case 'canceled':
        return const Color(0xFFFCE8E6);
      default:
        return const Color(0xFFE8F0FE);
    }
  }

  Color _fg() {
    switch (status) {
      case 'completed':
      case 'paid':
      case 'success':
        return const Color(0xFF1E8E3E);
      case 'failed':
      case 'canceled':
        return const Color(0xFFD93025);
      default:
        return const Color(0xFF1A73E8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: _bg(), borderRadius: BorderRadius.circular(999)),
      child: Text(status.toUpperCase(), style: TextStyle(color: _fg(), fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}


