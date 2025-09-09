import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class PaymentsSearchBar extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;

  const PaymentsSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Rechercher par référence, nom client...',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey[400],
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppConstants.brandBlue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
