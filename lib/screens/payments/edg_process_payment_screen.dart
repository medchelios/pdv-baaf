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

  void selectCustomerType(String type) {
    setState(() {
      customerType = type;
      step = 'enter_reference';
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
      if (customerType == 'postpaid') {
        final resp = await EdgService().getCustomerBills(customerReference);
        if (resp != null && resp['success'] == true) {
          final data = resp['data'] as Map<String, dynamic>;
          final fetchedBills = (data['bills'] as List)
              .cast<Map>()
              .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
              .toList();
          setState(() {
            customerData = {'name': data['customer_name'] ?? '-'};
            bills = fetchedBills.cast<Map<String, dynamic>>();
            step = 'select_bill';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resp?['error'] ?? 'Client non trouvé'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        setState(() {
          customerData = {'name': 'Client Prépayé'};
          step = 'enter_amount';
        });
      }
    } finally {
      setState(() => searching = false);
    }
  }

  Future<void> selectBill(Map<String, dynamic> bill) async {
    final billCode = bill['code'] as String;
    setState(() => searching = true);
    try {
      final billDetails = await EdgService().getBillDetails(billCode);
      if (billDetails != null && billDetails['success'] == true) {
        final data = billDetails['data'] as Map<String, dynamic>;
        setState(() {
          selectedBill = {
            'code': billCode,
            'amount': data['amount'],
            'amt': data['amount'],
            'period': bill['period'] ?? data['period'],
          };
          amount = null;
          customAmount = null;
          step = 'enter_amount';
        });
      } else {
        setState(() {
          selectedBill = bill;
          amount = null;
          customAmount = null;
          step = 'enter_amount';
        });
      }
    } finally {
      setState(() => searching = false);
    }
  }

  void setFullPayment() {
    if (selectedBill == null) return;
    final billAmt = selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0;
    setPaymentAmount(billAmt as int);
  }

  void setPartialPayment() {
    if (selectedBill == null || customAmount == null) return;
    final billAmt = selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0;
    final error = EdgValidator.validateAmount(customAmount, maxAmount: billAmt as int);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }
    setPaymentAmount(customAmount!);
  }

  void setAmount() {
    final error = EdgValidator.validateAmount(amount, minAmount: 1000);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }
    setPaymentAmount(amount!);
  }

  void setPaymentAmount(int amt) {
    final phoneError = EdgValidator.validatePhone(phoneNumber);
    if (phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(phoneError), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      amount = amt;
      step = 'confirm';
    });
  }

  Future<void> processPayment() async {
    setState(() => step = 'processing');
    final resp = await EdgService().processAgentPayment(
      customerType: customerType ?? 'postpaid',
      customerReference: customerType == 'prepaid' ? customerReference : null,
      billCode: customerType == 'postpaid' ? (selectedBill?['code'] as String?) : null,
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

  void goBack() {
    switch (step) {
      case 'enter_reference':
        if (typeLocked) {
          Navigator.of(context).maybePop();
        }
        break;
      case 'select_bill':
        setState(() => step = 'enter_reference');
        break;
      case 'enter_amount':
        setState(() {
          step = customerType == 'prepaid' ? 'enter_reference' : 'select_bill';
          amount = null;
          customAmount = null;
        });
        break;
      case 'confirm':
        setState(() => step = 'enter_amount');
        break;
      case 'processing':
        setState(() => step = 'confirm');
        break;
    }
  }

  void resetForm() {
    setState(() {
      step = 'enter_reference';
      customerType = null;
      customerReference = '';
      phoneNumber = null;
      customerData = null;
      bills = null;
      selectedBill = null;
      amount = null;
      customAmount = null;
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
          key: const ValueKey('select_bill'),
          bills: bills,
          onBillSelected: selectBill,
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
