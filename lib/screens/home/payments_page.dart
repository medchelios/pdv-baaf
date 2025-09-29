import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/payment_service.dart';
import 'widgets/payments_table.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  List<Map<String, dynamic>> _payments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await PaymentService().getPayments(
        page: _currentPage,
        limit: _itemsPerPage,
        search: _searchQuery,
      );

      if (result != null && result['payments'] != null) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(result['payments']);
        });
      }
    } catch (e) {
      // Erreur silencieuse
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppConstants.brandBlue,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
        flexibleSpace: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Barre de recherche
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        _currentPage = 1;
                      });
                      _loadPayments();
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher par référence, nom client...',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white70,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Bouton filtre
              Container(
                height: 40,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implémenter les filtres
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Filtrer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPayments,
              child: PaymentsTable(
                payments: _payments,
                currentPage: _currentPage,
                itemsPerPage: _itemsPerPage,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                  _loadPayments();
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPaymentOptions(context);
        },
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPaymentOptions(BuildContext context) {
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
            // Handle bar
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
              'Nouveau Paiement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            // Payment options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildPaymentOption(
                    context,
                    icon: Icons.electrical_services,
                    title: 'Paiement Électricité',
                    subtitle: 'Payer une facture d\'électricité',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to electricity payment
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                    context,
                    icon: Icons.phone,
                    title: 'Paiement Mobile',
                    subtitle: 'Recharger un téléphone',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to mobile payment
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

  Widget _buildPaymentOption(
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
            border: Border.all(
              color: const Color(0xFFE9ECEF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.brandBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppConstants.brandBlue,
                  size: 24,
                ),
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
