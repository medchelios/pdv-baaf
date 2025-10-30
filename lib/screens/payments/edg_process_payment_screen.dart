import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class EdgProcessPaymentScreen extends StatelessWidget {
  const EdgProcessPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String typeLabel = '';
    if (args is Map && args['type'] is String) {
      final t = (args['type'] as String).toLowerCase();
      typeLabel = t == 'prepaid'
          ? 'Prépayé'
          : t == 'postpaid'
          ? 'Postpayé'
          : '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${typeLabel.isNotEmpty ? '· $typeLabel' : ''}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandWhite),
        ),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: Text(
          typeLabel.isNotEmpty
              ? 'Flux EDG ($typeLabel) — à implémenter'
              : 'Sélectionnez un type depuis le menu',
          style: const TextStyle(color: AppConstants.textPrimary),
        ),
      ),
    );
  }
}
