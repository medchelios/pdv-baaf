import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';

class ProcessingWidget extends StatelessWidget {
  const ProcessingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.brandOrange),
            strokeWidth: 4,
          ),
          const SizedBox(height: 32),
          const Text(
            'Traitement en cours...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Veuillez patienter',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

