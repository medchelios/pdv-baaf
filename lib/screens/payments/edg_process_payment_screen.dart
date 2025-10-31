import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/edg_service.dart';
import '../../services/edg_validator.dart';
import 'edg/widgets/enter_reference_widget.dart';
import 'edg/widgets/select_bill_widget.dart';
import 'edg/widgets/enter_amount_widget.dart';
import 'edg/widgets/confirm_widget.dart';
import 'edg/widgets/processing_widget.dart';
import '../../controllers/payments/edg_process_payment_controller.dart';

class EdgProcessPaymentScreen extends StatefulWidget {
  const EdgProcessPaymentScreen({super.key});

  @override
  State<EdgProcessPaymentScreen> createState() =>
      _EdgProcessPaymentScreenState();
}

class _EdgProcessPaymentScreenState extends State<EdgProcessPaymentScreen> {
  late final EdgProcessPaymentController c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    c = EdgProcessPaymentController();
    c.addListener(() => mounted ? setState(() {}) : null);
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['type'] is String && c.customerType == null) {
      c.initWithType(args['type'] as String);
    } else if (c.customerType == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  Future<void> selectCustomerType(String type) => c.selectCustomerType(type);

  Future<void> validateReference() async {
    final error = EdgValidator.validateReference(
      c.customerReference,
      c.customerType == 'prepaid',
    );
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => c.searching = true);
    try {
      final resp = await c.validateReference();
      if (resp == null) return;
      if (resp['success'] == true) {
        // state already updated by controller
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resp['error'] ?? resp['message'] ?? 'Client non trouvé',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => c.searching = false);
    }
  }

  Future<void> selectBill(Map<String, dynamic> bill) async {
    setState(() => c.searching = true);
    try {
      final resp = await c.selectBillAction(bill);
      if (resp == null) return;
      if (resp['success'] == true) {
        // state already updated
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resp['message'] ?? 'Facture introuvable'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => c.searching = false);
    }
  }

  Future<void> setFullPayment() async {
    if (c.selectedBill == null) return;
    final resp = await c.setFullPayment();
    if (resp != null && resp['success'] == true) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp?['message'] ?? 'Montant invalide'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> setPartialPayment() async {
    if (c.selectedBill == null || c.customAmount == null) return;
    final resp = await c.setPartialPayment();
    if (resp != null && resp['success'] == true) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp?['message'] ?? 'Montant invalide'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> setAmount() async {
    if (c.amount == null) return;
    final resp = await c.setAmountAction();
    if (resp != null && resp['success'] == true) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp?['message'] ?? 'Montant invalide'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> moveToConfirm() async {
    // Validation simple côté client avant de passer à la confirmation
    final phoneError = EdgValidator.validatePhone(c.phoneNumber);
    if (phoneError != null || (c.amount == null || c.amount! < 1000)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(phoneError ?? 'Montant invalide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => c.moveToConfirm());
  }

  void setPaymentAmount(int amt) {
    setState(() {
      c.amount = amt;
      c.step = 'confirm';
    });
  }

  Future<void> processPayment() async {
    setState(() => c.step = 'processing');
    final resp = await EdgService().processAgentPayment(
      customerType: c.customerType ?? 'postpaid',
      customerReference: (c.customerReference.isEmpty
          ? null
          : c.customerReference),
      customerName: c.customerData?['name'] as String?,
      billCode: c.customerType == 'postpaid'
          ? (c.selectedBill?['code'] as String?)
          : null,
      billDate: c.customerType == 'postpaid'
          ? (c.selectedBill?['period'] as String?)
          : null,
      amount: c.amount ?? 0,
      phone: c.phoneNumber ?? '',
    );
    if (!mounted) return;
    if (resp != null && resp['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paiement en cours de traitement'),
          backgroundColor: Colors.green,
        ),
      );
      // Retour à la liste des paiements et actualisation
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/payments', (route) => route.isFirst);
    } else {
      setState(() => c.step = 'confirm');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resp?['error'] ?? resp?['message'] ?? 'Échec du paiement',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> goBack() async {
    // Réplique de PaymentWorkflow::getNextStep + cas spécial select_bill
    if (c.step == 'select_bill' && c.selectedBill != null) {
      setState(() {
        c.selectedBill = null;
        c.customAmount = null;
      });
      return;
    }

    switch (c.step) {
      case 'enter_reference':
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).maybePop();
        }
        return;
      case 'enter_amount':
      case 'select_bill':
        setState(() => c.step = 'enter_reference');
        return;
      case 'confirm':
        setState(
          () => c.step = c.customerType == 'prepaid'
              ? 'enter_amount'
              : 'select_bill',
        );
        return;
      default:
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).maybePop();
        }
        return;
    }
  }

  Future<void> resetForm() async {
    await c.resetForm();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final typeLabel = c.customerType == 'prepaid'
        ? 'Prépayé'
        : c.customerType == 'postpaid'
        ? 'Postpayé'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          typeLabel.isNotEmpty ? 'Facture EDG · $typeLabel' : 'Facture EDG',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppConstants.brandWhite),
        ),
        leading: BackButton(onPressed: goBack),
        backgroundColor: AppConstants.brandOrange,
        foregroundColor: AppConstants.brandWhite,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WillPopScope(
        onWillPop: () async {
          if (c.step == 'enter_reference') {
            return true;
          }
          await goBack();
          return false;
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _buildStep(),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (c.step) {
      case 'enter_reference':
        return EnterReferenceWidget(
          key: const ValueKey('enter_reference'),
          customerType: c.customerType,
          customerReference: c.customerReference,
          searching: c.searching,
          onReferenceChanged: (v) => setState(() => c.customerReference = v),
          onValidate: validateReference,
          onBack: goBack,
        );
      case 'select_bill':
        return SelectBillWidget(
          key: ValueKey('select_bill_${c.selectedBill?['code'] ?? 'list'}'),
          customerData: c.customerData,
          bills: c.bills,
          selectedBill: c.selectedBill,
          phoneNumber: c.phoneNumber,
          customAmount: c.customAmount,
          onBillSelected: (bill) {
            if (bill.isEmpty) {
              // Retour à la liste des factures
              setState(() {
                c.selectedBill = null;
                c.phoneNumber = null;
                c.amount = null;
                c.customAmount = null;
              });
            } else {
              selectBill(bill);
            }
          },
          onPhoneChanged: (v) => setState(() => c.phoneNumber = v),
          onCustomAmountChanged: (v) => setState(() => c.customAmount = v),
          onFullPayment: setFullPayment,
          onPartialPayment: setPartialPayment,
          onBack: goBack,
        );
      case 'enter_amount':
        return EnterAmountWidget(
          key: const ValueKey('enter_amount'),
          customerType: c.customerType,
          customerData: c.customerData,
          bill: c.selectedBill,
          phoneNumber: c.phoneNumber,
          amount: c.amount,
          customAmount: c.customAmount,
          onPhoneChanged: (v) => setState(() => c.phoneNumber = v),
          onAmountChanged: (v) => setState(() => c.amount = v),
          onCustomAmountChanged: (v) => setState(() => c.customAmount = v),
          onFullPayment: setFullPayment,
          onPartialPayment: setPartialPayment,
          onConfirm: moveToConfirm,
          onBack: goBack,
        );
      case 'confirm':
        return ConfirmWidget(
          key: const ValueKey('confirm'),
          customerType: c.customerType,
          customerData: c.customerData,
          customerReference: c.customerReference,
          phoneNumber: c.phoneNumber,
          selectedBillCode: c.selectedBill?['code'] as String?,
          selectedBillPeriod: c.selectedBill?['period'] as String?,
          amount: c.amount,
          onBack: goBack,
          onProcess: processPayment,
        );
      case 'processing':
        return const ProcessingWidget(key: ValueKey('processing'));
      default:
        return EnterReferenceWidget(
          key: const ValueKey('default'),
          customerType: c.customerType,
          customerReference: c.customerReference,
          searching: c.searching,
          onReferenceChanged: (v) => setState(() => c.customerReference = v),
          onValidate: validateReference,
          onBack: goBack,
        );
    }
  }
}
