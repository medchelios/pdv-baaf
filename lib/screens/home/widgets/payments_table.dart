import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/payment_service.dart';
import '../../payments/widgets/payment_details_dialog.dart';

class PaymentsTable extends StatefulWidget {
  final String searchQuery;
  final int currentPage;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const PaymentsTable({
    super.key,
    required this.searchQuery,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  State<PaymentsTable> createState() => _PaymentsTableState();
}

class _PaymentsTableState extends State<PaymentsTable> {
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
  void didUpdateWidget(PaymentsTable oldWidget) {
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
      final result = await PaymentService().getPayments(
        page: widget.currentPage,
        limit: widget.itemsPerPage,
        search: widget.searchQuery,
      );

      if (result != null) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(result['payments'] ?? []);
          _totalItems = result['total'] ?? 0;
          _totalPages = (result['total'] / widget.itemsPerPage).ceil();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
      child: Column(
        children: [
          // En-tête du tableau
          _buildTableHeader(),
          // Corps du tableau
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.brandBlue,
                    ),
                  )
                : _payments.isEmpty
                    ? _buildEmptyState()
                    : _buildTableBody(),
          ),
          // Pagination
          if (_totalPages > 1) _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Référence',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Client',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Montant',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Statut',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Actions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody() {
    return ListView.builder(
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        final payment = _payments[index];
        return _buildTableRow(payment, index);
      },
    );
  }

  Widget _buildTableRow(Map<String, dynamic> payment, int index) {
    final isEven = index % 2 == 0;
    
    return Container(
      decoration: BoxDecoration(
        color: isEven ? Colors.white : const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    payment['reference'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['subscriber_name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment['payment_method_label'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    payment['formatted_amount'] ?? '0 GNF',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.brandBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(payment['status']),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        payment['status_label'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(payment['status']),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    payment['formatted_created_at']?.split(' ')[0] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => PaymentDetailsDialog(paymentData: payment),
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppConstants.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'Aucun paiement trouvé',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE9ECEF),
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
              // Numéros de page
              ..._buildPageNumbers(),
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

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];
    
    // Page 1
    pages.add(_buildPageNumber(1));
    
    if (_totalPages > 1) {
      pages.add(_buildPageNumber(2));
    }
    
    if (_totalPages > 2) {
      pages.add(const Text('...', style: TextStyle(color: Colors.grey)));
      pages.add(_buildPageNumber(_totalPages));
    }
    
    return pages;
  }

  Widget _buildPageNumber(int page) {
    final isActive = page == widget.currentPage;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppConstants.brandBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppConstants.brandBlue : const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          page.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppConstants.textPrimary,
          ),
        ),
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
