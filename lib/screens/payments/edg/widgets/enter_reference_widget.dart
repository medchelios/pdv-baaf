import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../services/edg_validator.dart';

class EnterReferenceWidget extends StatelessWidget {
  final String? customerType;
  final String customerReference;
  final bool searching;
  final Function(String) onReferenceChanged;
  final VoidCallback onValidate;
  final VoidCallback onBack;

  const EnterReferenceWidget({
    super.key,
    required this.customerType,
    required this.customerReference,
    required this.searching,
    required this.onReferenceChanged,
    required this.onValidate,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isPrepaid = customerType == 'prepaid';
    final maxLength = isPrepaid ? 11 : 13;
    final hintText = isPrepaid ? 'Ex: 37224456899' : 'Ex: 0220580350130';
    final labelText = isPrepaid ? 'Numéro de compteur' : 'Référence client';
    final validationError = EdgValidator.validateReference(customerReference, isPrepaid);
    final canValidate = customerReference.length >= 3 && validationError == null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Input référence
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: validationError != null && customerReference.isNotEmpty
                    ? Colors.red
                    : AppConstants.brandOrange.withValues(alpha: 0.3),
                width: 2,
              ),
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
                TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  maxLength: maxLength,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: onReferenceChanged,
                ),
                // Compteur
                Text(
                  '${customerReference.length}/$maxLength caractères',
                  style: TextStyle(
                    fontSize: 12,
                    color: customerReference.length == maxLength
                        ? Colors.green
                        : AppConstants.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Message d'erreur
          if (validationError != null && customerReference.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              validationError,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 32),
          // Bouton recherche
          if (canValidate)
            ElevatedButton.icon(
              onPressed: searching ? null : onValidate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.brandOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: searching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search, size: 20),
              label: Text(searching ? 'Recherche...' : 'Rechercher'),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

