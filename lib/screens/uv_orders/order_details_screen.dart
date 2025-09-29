import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'widgets/order_info_section.dart';
import 'widgets/order_details_section.dart';
import 'widgets/order_actions_section.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails de la commande',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandBlue),
        ),
        backgroundColor: AppConstants.brandWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.brandBlue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderInfoSection(order: order),
            const SizedBox(height: AppConstants.paddingL),
            OrderDetailsSection(order: order),
            const SizedBox(height: AppConstants.paddingL),
            OrderActionsSection(order: order),
          ],
        ),
      ),
    );
  }
}
