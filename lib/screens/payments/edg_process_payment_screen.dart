import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/edg_service.dart';
import '../../services/edg_validator.dart';
import 'edg/widgets/enter_reference_widget.dart';
import 'edg/widgets/select_bill_widget.dart';
import 'edg/widgets/enter_amount_widget.dart';
import 'edg/widgets/confirm_widget.dart';
import 'edg/widgets/processing_widget.dart';

class EdgProcessPaymentScreen extends StatefulWidget {
  const EdgProcessPaymentScreen({super.key});

  @override
  State<EdgProcessPaymentScreen> createState() => _EdgProcessPaymentScreenState();
}

class _EdgProcessPaymentScreenState extends State<EdgProcessPaymentScreen> {
  String step = 'enter_reference';
  String? customerType;
  String customerReference = '';
  String? phoneNumber;
  bool typeLocked = false;

  Map<String, dynamic>? customerData;
  List<Map<String, dynamic>>? bills;
  Map<String, dynamic>? selectedBill;

  int? amount;
  int? customAmount;
  bool searching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['type'] is String && customerType == null) {
      typeLocked = true;
      selectCustomerType((args['type'] as String).toLowerCase());
    } else if (customerType == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  Future<void> selectCustomerType(String type) async {
    final resp = await EdgService().selectType(customerType: type);
    if (resp == null || resp['success'] != true) return;
    final data = resp['data'] as Map<String, dynamic>?;
    setState(() {
      customerType = data?['customer_type']?.toString() ?? type;
      step = data?['step']?.toString() ?? 'enter_reference';
      customerReference = '';
      phoneNumber = null;
      customerData = null;
      bills = null;
      selectedBill = null;
      amount = null;
      customAmount = null;
    });
  }

  Future<void> validateReference() async {
    final error = EdgValidator.validateReference(customerReference, customerType == 'prepaid');
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => searching = true);
    try {
      final resp = await EdgService().validateCustomer(
        customerType: customerType ?? 'postpaid',
        customerReference: customerReference,
      );
      if (resp == null) return;
      if (resp['success'] == true) {
        final data = resp['data'] as Map<String, dynamic>?;
        final list = (resp['bills'] as List?)?.cast<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
        setState(() {
          customerData = data;
          bills = list?.cast<Map<String, dynamic>>();
          step = (resp['next_step']?.toString() ?? (customerType == 'prepaid' ? 'enter_amount' : 'select_bill'));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resp['error'] ?? resp['message'] ?? 'Client non trouvé'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => searching = false);
    }
  }

  Future<void> selectBill(Map<String, dynamic> bill) async {
    final billCode = bill['code'] as String;
    setState(() => searching = true);
    try {
      final resp = await EdgService().selectBill(
        bills: (bills ?? []).cast<Map<String, dynamic>>(),
        billCode: billCode,
      );
      if (resp == null) return;
      if (resp['success'] == true) {
        final data = resp['data'] as Map<String, dynamic>;
        setState(() {
          selectedBill = {
            'code': data['selected_bill'] ?? billCode,
            'period': data['selected_bill_period'] ?? bill['period'],
            'amount': bill['amount'] ?? bill['amt'],
            'amt': bill['amount'] ?? bill['amt'],
          };
          amount = null;
          customAmount = null;
          step = data['next_step']?.toString() ?? 'enter_amount';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resp['message'] ?? 'Facture introuvable'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => searching = false);
    }
  }

  Future<void> setFullPayment() async {
    if (selectedBill == null) return;
    final billAmt = (selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0) as int;
    final resp = await EdgService().setFullPayment(billAmount: billAmt, phoneNumber: phoneNumber ?? '');
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      setState(() {
        amount = (data['amount'] as num?)?.toInt();
        step = data['next_step']?.toString() ?? 'confirm';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp?['message'] ?? 'Montant invalide'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> setPartialPayment() async {
    if (selectedBill == null || customAmount == null) return;
    final billAmt = (selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0) as int;
    final resp = await EdgService().setPartialPayment(
      customAmount: customAmount!,
      billAmount: billAmt,
      phoneNumber: phoneNumber ?? '',
    );
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      setState(() {
        amount = (data['amount'] as num?)?.toInt();
        step = data['next_step']?.toString() ?? 'confirm';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp?['message'] ?? 'Montant invalide'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> setAmount() async {
    if (amount == null) return;
    final resp = await EdgService().setAmount(amount: amount!, phoneNumber: phoneNumber ?? '');
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      setState(() {
        amount = (data['amount'] as num?)?.toInt();
        step = data['next_step']?.toString() ?? 'confirm';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp?['message'] ?? 'Montant invalide'), backgroundColor: Colors.red),
      );
    }
  }

  void setPaymentAmount(int amt) {
    setState(() {
      amount = amt;
      step = 'confirm';
    });
  }

  Future<void> processPayment() async {
    setState(() => step = 'processing');
    final resp = await EdgService().processAgentPayment(
      customerType: customerType ?? 'postpaid',
      customerReference: customerReference.isEmpty ? null : customerReference,
      customerName: customerData?['name'] as String?,
      billCode: customerType == 'postpaid' ? (selectedBill?['code'] as String?) : null,
      billDate: customerType == 'postpaid' ? (selectedBill?['period'] as String?) : null,
      amount: amount ?? 0,
      phone: phoneNumber ?? '',
    );
    if (!mounted) return;
    if (resp != null && resp['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paiement en cours de traitement'),
          backgroundColor: Colors.green,
        ),
      );
      resetForm();
    } else {
      setState(() => step = 'confirm');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp?['error'] ?? resp?['message'] ?? 'Échec du paiement'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> goBack() async {
    final resp = await EdgService().goBack(
      currentStep: step,
      customerType: customerType,
      selectedBill: selectedBill?['code'] as String?,
    );
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      setState(() {
        step = data['next_step']?.toString() ?? step;
        if (step == 'select_bill') {
          amount = null;
          customAmount = null;
        }
        if (step == 'enter_reference' && selectedBill != null) {
          selectedBill = null;
          phoneNumber = null;
          amount = null;
          customAmount = null;
        }
      });
    }
  }

  Future<void> resetForm() async {
    final resp = await EdgService().resetForm();
    final data = (resp != null && resp['success'] == true)
        ? (resp['data'] as Map<String, dynamic>?)
        : null;
    setState(() {
      step = data?['step']?.toString() ?? 'enter_reference';
      customerType = data?['customerType']?.toString();
      customerReference = (data?['customerReference']?.toString() ?? '');
      phoneNumber = data?['phoneNumber']?.toString();
      customerData = data?['customerData'] as Map<String, dynamic>?;
      bills = (data?['bills'] as List?)?.cast<Map<String, dynamic>>();
      selectedBill = data?['selectedBill'] as Map<String, dynamic>?;
      amount = (data?['amount'] as num?)?.toInt();
      customAmount = (data?['customAmount'] as num?)?.toInt();
      typeLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final typeLabel = customerType == 'prepaid'
        ? 'Prépayé'
        : customerType == 'postpaid'
            ? 'Postpayé'
            : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          typeLabel.isNotEmpty ? 'Facture EDG · $typeLabel' : 'Facture EDG',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.brandWhite,
              ),
        ),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    switch (step) {
      case 'enter_reference':
        return EnterReferenceWidget(
          key: const ValueKey('enter_reference'),
          customerType: customerType,
          customerReference: customerReference,
          searching: searching,
          onReferenceChanged: (v) => setState(() => customerReference = v),
          onValidate: validateReference,
          onBack: goBack,
        );
      case 'select_bill':
        return SelectBillWidget(
          key: ValueKey('select_bill_${selectedBill?['code'] ?? 'list'}'),
          bills: bills,
          selectedBill: selectedBill,
          phoneNumber: phoneNumber,
          customAmount: customAmount,
          onBillSelected: (bill) {
            if (bill.isEmpty) {
              // Retour à la liste des factures
              setState(() {
                selectedBill = null;
                phoneNumber = null;
                amount = null;
                customAmount = null;
              });
            } else {
              selectBill(bill);
            }
          },
          onPhoneChanged: (v) => setState(() => phoneNumber = v),
          onCustomAmountChanged: (v) => setState(() => customAmount = v),
          onFullPayment: setFullPayment,
          onPartialPayment: setPartialPayment,
          onBack: goBack,
        );
      case 'enter_amount':
        return EnterAmountWidget(
          key: const ValueKey('enter_amount'),
          customerType: customerType,
          customerData: customerData,
          bill: selectedBill,
          phoneNumber: phoneNumber,
          amount: amount,
          customAmount: customAmount,
          onPhoneChanged: (v) => setState(() => phoneNumber = v),
          onAmountChanged: (v) => setState(() => amount = v),
          onCustomAmountChanged: (v) => setState(() => customAmount = v),
          onFullPayment: setFullPayment,
          onPartialPayment: setPartialPayment,
          onConfirm: setAmount,
          onBack: goBack,
        );
      case 'confirm':
        return ConfirmWidget(
          key: const ValueKey('confirm'),
          customerType: customerType,
          customerData: customerData,
          customerReference: customerReference,
          phoneNumber: phoneNumber,
          selectedBillCode: selectedBill?['code'] as String?,
          selectedBillPeriod: selectedBill?['period'] as String?,
          amount: amount,
          onBack: goBack,
          onProcess: processPayment,
        );
      case 'processing':
        return const ProcessingWidget(key: ValueKey('processing'));
      default:
        return EnterReferenceWidget(
          key: const ValueKey('default'),
          customerType: customerType,
          customerReference: customerReference,
          searching: searching,
          onReferenceChanged: (v) => setState(() => customerReference = v),
          onValidate: validateReference,
          onBack: goBack,
        );
    }
  }
}
