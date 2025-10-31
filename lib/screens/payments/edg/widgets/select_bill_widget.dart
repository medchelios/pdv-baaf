import 'package:flutter/material.dart';
import '../../../../services/edg_validator.dart';
import '../../../../utils/format_utils.dart';

class SelectBillWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? bills;
  final Map<String, dynamic>? selectedBill;
  final Map<String, dynamic>? customerData;
  final String? phoneNumber;
  final int? customAmount;
  final Function(Map<String, dynamic>) onBillSelected;
  final Function(String) onPhoneChanged;
  final Function(int?) onCustomAmountChanged;
  final VoidCallback onFullPayment;
  final VoidCallback onPartialPayment;
  final VoidCallback onBack;

  const SelectBillWidget({
    super.key,
    required this.bills,
    required this.selectedBill,
    required this.customerData,
    required this.phoneNumber,
    required this.customAmount,
    required this.onBillSelected,
    required this.onPhoneChanged,
    required this.onCustomAmountChanged,
    required this.onFullPayment,
    required this.onPartialPayment,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (customerData != null) ...[
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Client'),
                        Text(
                          customerData?['name']?.toString() ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if ((customerData?['customer_code']?.toString() ?? '')
                        .isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Code client'),
                          Text(
                            customerData?['customer_code']?.toString() ?? '-',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (customerData?['arrear'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Arriéré'),
                          Text(
                            '${FormatUtils.formatAmount((customerData?['arrear'] ?? 0).toString())} GNF',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (selectedBill == null) ...[
            // Liste des factures
            const SizedBox(height: 32),
            const Text(
              'Sélectionner la facture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (bills == null || bills!.isEmpty)
              const Text(
                'Aucune facture disponible',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              )
            else
              ...bills!.map((bill) {
                final amount = bill['amount'] ?? bill['amt'] ?? 0;
                final period = bill['period'] ?? '';
                final code = bill['code'] ?? '';

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    title: Text('Facture $code'),
                    subtitle: period.isNotEmpty
                        ? Text('Période: $period')
                        : null,
                    trailing: Text(
                      '${FormatUtils.formatAmount(amount.toString())} GNF',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => onBillSelected(bill),
                  ),
                );
              }),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBack,
                child: const Text('Retour'),
              ),
            ),
          ] else ...[
            // Options de paiement après sélection (comme backend PHP)
            const SizedBox(height: 32),
            Text(
              'Facture ${selectedBill!['code']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${FormatUtils.formatAmount((selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0).toString())} GNF',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Téléphone
            _PhoneField(
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone *',
                border: const OutlineInputBorder(),
                // L'erreur s'affiche seulement après interaction dans _PhoneField
              ),
              keyboardType: TextInputType.phone,
              maxLength: 20,
              style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1),
              onChanged: onPhoneChanged,
              value: phoneNumber ?? '',
            ),
            const SizedBox(height: 32),
            // Paiement complet
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: EdgValidator.isValidPhoneNumber(phoneNumber ?? '')
                    ? onFullPayment
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Paiement complet: ${FormatUtils.formatAmount((selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0).toString())} GNF',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Paiement partiel
            const Text(
              'Paiement partiel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _AmountField(
              decoration: InputDecoration(
                labelText: 'Montant en GNF',
                border: const OutlineInputBorder(),
                // L'erreur s'affiche seulement après interaction dans _AmountField
              ),
              onChanged: (v) => onCustomAmountChanged(int.tryParse(v)),
              value: customAmount?.toString() ?? '',
              max:
                  (selectedBill?['amount'] ?? selectedBill?['amt'] ?? 0) as int,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (customAmount != null &&
                        customAmount! >= 1000 &&
                        customAmount! <= (selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0) &&
                        EdgValidator.isValidPhoneNumber(phoneNumber ?? ''))
                    ? onPartialPayment
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Payer ${FormatUtils.formatAmount((customAmount ?? 0).toString())} GNF',
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Retour'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneField extends StatefulWidget {
  final InputDecoration decoration;
  final String value;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final int maxLength;
  final TextStyle style;

  const _PhoneField({
    required this.decoration,
    required this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.phone,
    this.maxLength = 20,
    this.style = const TextStyle(),
  });

  @override
  State<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<_PhoneField> {
  bool touched = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _PhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = EdgValidator.validatePhone(widget.value);
    return TextField(
      controller: _controller,
      decoration: widget.decoration.copyWith(
        errorText: touched && widget.value.isNotEmpty ? error : null,
      ),
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      style: widget.style.copyWith(fontFamily: 'monospace', letterSpacing: 1),
      onChanged: (v) {
        if (!touched) setState(() => touched = true);
        widget.onChanged(v);
      },
    );
  }
}

class _AmountField extends StatefulWidget {
  final InputDecoration decoration;
  final String value;
  final int max;
  final Function(String) onChanged;

  const _AmountField({
    required this.decoration,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  bool touched = false;

  @override
  Widget build(BuildContext context) {
    final parsed = int.tryParse(widget.value);
    final invalid = parsed != null && (parsed <= 0 || parsed > widget.max);
    return TextField(
      decoration: widget.decoration.copyWith(
        errorText: touched && invalid ? 'Montant invalide' : null,
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) {
        if (!touched) setState(() => touched = true);
        widget.onChanged(v);
      },
    );
  }
}
