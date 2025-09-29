import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class OrdersPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const OrdersPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 0
              ? () => onPageChanged(currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          '${currentPage + 1} / $totalPages',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppConstants.brandBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: currentPage < totalPages - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
