import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          if (widget.customerData != null) ...[
            Text(
              'Client: ${widget.customerData!['name'] ?? '-'}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
          Text(
            widget.customerType == 'prepaid' ? 'Montant de recharge' : 'Montant',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (billAmt != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onFullPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Total: ${FormatUtils.formatAmount(billAmt.toString())} GNF',
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
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
            if (widget.amount != null) ...[
              const SizedBox(height: 16),
              Text(
                'Montant sélectionné: ${FormatUtils.formatAmount(widget.amount.toString())} GNF',
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ] else ...[
            TextField(
              decoration: InputDecoration(
                labelText: 'Montant en GNF',
                border: const OutlineInputBorder(),
                errorText: amountError,
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onChanged: (v) => widget.onAmountChanged(int.tryParse(v)),
            ),
            if (widget.amount != null && widget.amount! > 0) ...[
              const SizedBox(height: 12),
              Text(
                '${FormatUtils.formatAmount(widget.amount.toString())} GNF',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Minimum: 1,000 GNF',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 32),
          const Text(
            'Numéro de téléphone *',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Veuillez saisir le numéro',
              border: const OutlineInputBorder(),
              errorText: phoneError,
            ),
            keyboardType: TextInputType.phone,
            maxLength: 20,
            style: const TextStyle(
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
            onChanged: widget.onPhoneChanged,
          ),
          if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              isValidPhone
                  ? 'Format valide'
                  : 'Format invalide. 9 chiffres commençant par 6, 7, ou 8',
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
                'Pour recevoir un SMS de confirmation (obligatoire)',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 32),
          if (canConfirm)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onConfirm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Confirmer ${FormatUtils.formatAmount((widget.amount ?? 0).toString())} GNF',
                ),
              ),
            )
          else if ((billAmt != null || (widget.amount != null && widget.amount! >= 1000)) &&
              (widget.phoneNumber == null || widget.phoneNumber!.isEmpty || !isValidPhone))
            Text(
              phoneError ?? 'Veuillez remplir tous les champs correctement',
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onBack,
              child: const Text('Retour'),
            ),
          ),
        ],
      ),
    );
  }
}
