import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              errorText: validationError != null && customerReference.isNotEmpty
                  ? validationError
                  : null,
              counterText: '${customerReference.length}/$maxLength',
            ),
            maxLength: maxLength,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
            onChanged: onReferenceChanged,
          ),
          const SizedBox(height: 32),
          if (canValidate)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: searching ? null : onValidate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: searching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Rechercher'),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onBack,
              child: const Text('Retour'),
            ),
          ),
        ],
      ),
    );
  }
}
