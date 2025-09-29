import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class PaymentsHeader extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;

  const PaymentsHeader({
    super.key,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
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
          // Barre de recherche
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE9ECEF),
                  width: 1,
                ),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Rechercher par référence, nom client...',
                  hintStyle: TextStyle(
                    color: Color(0xFF6C757D),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF6C757D),
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
              onPressed: onFilterPressed,
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: AppConstants.brandBlue,
              ),
              label: const Text(
                'Filtrer',
                style: TextStyle(
                  color: AppConstants.brandBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppConstants.brandBlue,
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
    );
  }
}
