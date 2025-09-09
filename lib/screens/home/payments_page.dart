import 'package:flutter/material.dart';
import 'widgets/payments_header.dart';
import 'widgets/payments_table.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header avec titre, recherche et filtres
          PaymentsHeader(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
                _currentPage = 1;
              });
            },
            onFilterPressed: () {
              // TODO: Implémenter les filtres
            },
          ),
          // Tableau des paiements
          Expanded(
            child: PaymentsTable(
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