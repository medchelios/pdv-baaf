import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../services/edg_validator.dart';
import '../../../../utils/format_utils.dart';

class EnterAmountWidget extends StatefulWidget {
  final String? customerType;
  final Map<String, dynamic>? customerData;
  final Map<String, dynamic>? bill;
  final String? phoneNumber;
  final int? amount;
  final int? customAmount;
  final Function(String) onPhoneChanged;
  final Function(int?) onAmountChanged;
  final Function(int?) onCustomAmountChanged;
  final VoidCallback onFullPayment;
  final VoidCallback onPartialPayment;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const EnterAmountWidget({
    super.key,
    required this.customerType,
    required this.customerData,
    required this.bill,
    required this.phoneNumber,
    required this.amount,
    required this.customAmount,
    required this.onPhoneChanged,
    required this.onAmountChanged,
    required this.onCustomAmountChanged,
    required this.onFullPayment,
    required this.onPartialPayment,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  State<EnterAmountWidget> createState() => _EnterAmountWidgetState();
}

class _EnterAmountWidgetState extends State<EnterAmountWidget> {
  @override
  Widget build(BuildContext context) {
    final billAmt = widget.bill != null ? (widget.bill!['amount'] ?? widget.bill!['amt'] ?? 0) : null;
    final phoneError = EdgValidator.validatePhone(widget.phoneNumber);
    final isValidPhone = EdgValidator.isValidPhoneNumber(widget.phoneNumber ?? '');
    final amountError = billAmt != null
        ? null
        : EdgValidator.validateAmount(widget.amount, minAmount: 1000);

    final canConfirm = billAmt != null
        ? widget.amount != null && isValidPhone
        : widget.amount != null &&
            widget.amount! >= 1000 &&
            isValidPhone &&
            amountError == null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info client
          if (widget.customerData != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppConstants.brandOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Client: ${widget.customerData!['name'] ?? '-'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          // Montant
          Text(
            widget.customerType == 'prepaid' ? 'Montant de recharge' : 'Montant',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (billAmt != null) ...[
            // Postpayé : Total ou Partiel
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: widget.onFullPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.brandOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Total: ${FormatUtils.formatAmount(billAmt.toString())} GNF',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Montant partiel',
                            border: const OutlineInputBorder(),
                            errorText: widget.customAmount != null &&
                                    (widget.customAmount! <= 0 ||
                                        widget.customAmount! > billAmt)
                                ? 'Montant invalide'
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              widget.onCustomAmountChanged(int.tryParse(v)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.amount != null ? widget.onPartialPayment : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                  if (widget.amount != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Montant sélectionné: ${FormatUtils.formatAmount(widget.amount.toString())} GNF',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.brandOrange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            // Prépayé : Saisie libre
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Montant en GNF',
                      hintText: 'Montant en GNF',
                      border: const OutlineInputBorder(),
                      errorText: amountError,
                      prefixText: 'GNF ',
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (v) => widget.onAmountChanged(int.tryParse(v)),
                  ),
                  if (widget.amount != null && widget.amount! > 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      '${FormatUtils.formatAmount(widget.amount.toString())} GNF',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.brandOrange,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    'Minimum: 1,000 GNF',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Téléphone
          const SizedBox(height: 32),
          const Text(
            'Numéro de téléphone *',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: phoneError != null && widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty
                    ? Colors.red
                    : Colors.grey.withValues(alpha: 0.3),
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
                    hintText: 'Veuillez saisir le numéro',
                    border: InputBorder.none,
                    errorText: phoneError,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 20,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  onChanged: widget.onPhoneChanged,
                ),
                if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    isValidPhone
                        ? '✅ Format valide (9 chiffres guinéen)'
                        : '❌ Format invalide. Le numéro doit avoir 9 chiffres et commencer par 6, 7, ou 8',
                    style: TextStyle(
                      fontSize: 12,
                      color: isValidPhone ? Colors.green : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Pour recevoir un SMS de confirmation du paiement (obligatoire)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Bouton confirmation
          if (canConfirm)
            ElevatedButton.icon(
              onPressed: widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.brandOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check, size: 24),
              label: Text(
                'Confirmer ${FormatUtils.formatAmount((widget.amount ?? 0).toString())} GNF',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if ((billAmt != null || (widget.amount != null && widget.amount! >= 1000)) &&
              (widget.phoneNumber == null || widget.phoneNumber!.isEmpty || !isValidPhone))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                phoneError ?? 'Veuillez remplir tous les champs correctement',
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: widget.onBack,
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

