import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/payment_service.dart';
import 'payment_details_dialog.dart';

class PaymentsList extends StatefulWidget {
  final String searchQuery;
  final int currentPage;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const PaymentsList({
    super.key,
    required this.searchQuery,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  State<PaymentsList> createState() => _PaymentsListState();
}

class _PaymentsListState extends State<PaymentsList> {
  List<Map<String, dynamic>> _payments = [];
  bool _isLoading = false;
  int _totalPages = 0;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  @override
  void didUpdateWidget(PaymentsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery || 
        oldWidget.currentPage != widget.currentPage) {
      _loadPayments();
    }
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final payments = await PaymentService().getPayments(
        page: widget.currentPage,
        limit: widget.itemsPerPage,
        search: widget.searchQuery,
      );

      if (payments != null) {
        setState(() {
          _payments = payments['data'] ?? [];
          _totalItems = payments['total'] ?? 0;
          _totalPages = (payments['total'] / widget.itemsPerPage).ceil();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: $e'),
            backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppConstants.brandBlue,
        ),
      );
    }

    if (_payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isEmpty
                  ? 'Aucun paiement trouvé'
                  : 'Aucun résultat pour "${widget.searchQuery}"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Clear search
                  widget.onPageChanged(1);
                },
                child: const Text('Effacer la recherche'),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        // Liste des paiements
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _payments.length,
            itemBuilder: (context, index) {
              final payment = _payments[index];
              return _buildPaymentItem(payment);
            },
          ),
        ),
        // Pagination
        if (_totalPages > 1)
          _buildPagination(),
      ],
    );
  }

  Widget _buildPaymentItem(Map<String, dynamic> payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => PaymentDetailsDialog(paymentData: payment),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec référence et statut
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payment['reference'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(payment['status']).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        payment['status_label'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(payment['status']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Client et montant
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment['subscriber_name'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            payment['payment_method_label'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          payment['formatted_amount'] ?? '0 GNF',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.brandBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payment['formatted_created_at'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${widget.currentPage} sur $_totalPages ($_totalItems paiements)',
            style: const TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondary,
            ),
          ),
          Row(
            children: [
              // Bouton précédent
              IconButton(
                onPressed: widget.currentPage > 1
                    ? () => widget.onPageChanged(widget.currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: widget.currentPage > 1
                    ? AppConstants.brandBlue
                    : Colors.grey,
              ),
              // Bouton suivant
              IconButton(
                onPressed: widget.currentPage < _totalPages
                    ? () => widget.onPageChanged(widget.currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: widget.currentPage < _totalPages
                    ? AppConstants.brandBlue
                    : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppConstants.brandBlue;
    }
  }
}
