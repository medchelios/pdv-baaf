import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'widgets/payments_list.dart';
import 'widgets/payments_search.dart';
import '../payment_type_screen.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Historique des Paiements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.brandBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Boutons d'action
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentTypeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Nouveau Paiement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.brandBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la recherche avancée
                    },
                    icon: const Icon(Icons.search, size: 20),
                    label: const Text('Recherche Avancée'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.brandBlue,
                      side: const BorderSide(color: AppConstants.brandBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Barre de recherche
          PaymentsSearch(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
                _currentPage = 1; // Reset to first page when searching
              });
            },
          ),
          // Liste des paiements
          Expanded(
            child: PaymentsList(
              searchQuery: _searchQuery,
              currentPage: _currentPage,
              itemsPerPage: _itemsPerPage,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
