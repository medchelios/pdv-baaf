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
  bool amountTouched = false;
  bool phoneTouched = false;
  @override
  Widget build(BuildContext context) {
    final billAmt = widget.bill != null
        ? (widget.bill!['amount'] ?? widget.bill!['amt'] ?? 0)
        : null;
    final phoneError = EdgValidator.validatePhone(widget.phoneNumber);
    final isValidPhone = EdgValidator.isValidPhoneNumber(
      widget.phoneNumber ?? '',
    );
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          if (widget.customerData != null) ...[
            ListTile(
              title: const Text('Client'),
              trailing: Text(
                widget.customerData!['name'] ?? '-',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const Divider(),
          ],
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
                      errorText:
                          amountTouched &&
                              widget.customAmount != null &&
                              (widget.customAmount! <= 0 ||
                                  widget.customAmount! > billAmt)
                          ? 'Montant invalide'
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      if (!amountTouched) setState(() => amountTouched = true);
                      widget.onCustomAmountChanged(int.tryParse(v));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        (widget.customAmount != null &&
                            widget.customAmount! > 0 &&
                            widget.customAmount! <= billAmt)
                        ? widget.onPartialPayment
                        : null,
                    child: const Text('Valider'),
                  ),
                ),
              ],
            ),
          ] else ...[
            TextField(
              decoration: InputDecoration(
                labelText: 'Montant en GNF',
                border: const OutlineInputBorder(),
                errorText: amountTouched ? amountError : null,
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18),
              onChanged: (v) {
                if (!amountTouched) setState(() => amountTouched = true);
                widget.onAmountChanged(int.tryParse(v));
              },
            ),
          ],
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone *',
              border: const OutlineInputBorder(),
              errorText: phoneTouched ? phoneError : null,
            ),
            keyboardType: TextInputType.phone,
            maxLength: 20,
            style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1),
            onChanged: (v) {
              if (!phoneTouched) setState(() => phoneTouched = true);
              widget.onPhoneChanged(v);
            },
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
