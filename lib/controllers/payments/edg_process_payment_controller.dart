import 'package:flutter/foundation.dart';
import '../../services/edg_service.dart';

class EdgProcessPaymentController extends ChangeNotifier {
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

  Future<void> initWithType(String? type) async {
    if (type == null) return;
    typeLocked = true;
    await selectCustomerType(type.toLowerCase());
  }

  Future<void> selectCustomerType(String type) async {
    final resp = await EdgService().selectType(customerType: type);
    if (resp == null || resp['success'] != true) return;
    final data = resp['data'] as Map<String, dynamic>?;
    customerType = data?['customer_type']?.toString() ?? type;
    step = data?['step']?.toString() ?? 'enter_reference';
    customerReference = '';
    phoneNumber = null;
    customerData = null;
    bills = null;
    selectedBill = null;
    amount = null;
    customAmount = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> validateReference() async {
    searching = true;
    notifyListeners();
    try {
      final resp = await EdgService().validateCustomer(
        customerType: customerType ?? 'postpaid',
        customerReference: customerReference,
      );
      if (resp == null) return null;
      if (resp['success'] == true) {
        final data = resp['data'] as Map<String, dynamic>?;
        final list = (resp['bills'] as List?)?.cast<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
        customerData = data;
        bills = list?.cast<Map<String, dynamic>>();
        step = (resp['next_step']?.toString() ?? (customerType == 'prepaid' ? 'enter_amount' : 'select_bill'));
        return resp;
      }
      return resp;
    } finally {
      searching = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> selectBillAction(Map<String, dynamic> bill) async {
    final billCode = bill['code'] as String;
    searching = true;
    notifyListeners();
    try {
      final resp = await EdgService().selectBill(
        bills: (bills ?? []).cast<Map<String, dynamic>>(),
        billCode: billCode,
      );
      if (resp == null) return null;
      if (resp['success'] == true) {
        final data = resp['data'] as Map<String, dynamic>;
        selectedBill = {
          'code': data['selected_bill'] ?? billCode,
          'period': data['selected_bill_period'] ?? bill['period'],
          'amount': bill['amount'] ?? bill['amt'],
          'amt': bill['amount'] ?? bill['amt'],
        };
        amount = null;
        customAmount = null;
        step = data['next_step']?.toString() ?? 'enter_amount';
      }
      return resp;
    } finally {
      searching = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> setFullPayment() async {
    if (selectedBill == null) return null;
    final billAmt = (selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0) as int;
    final resp = await EdgService().setFullPayment(billAmount: billAmt, phoneNumber: phoneNumber ?? '');
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      amount = (data['amount'] as num?)?.toInt();
      step = data['next_step']?.toString() ?? 'confirm';
      notifyListeners();
    }
    return resp;
  }

  Future<Map<String, dynamic>?> setPartialPayment() async {
    if (selectedBill == null || customAmount == null) return null;
    final billAmt = (selectedBill!['amount'] ?? selectedBill!['amt'] ?? 0) as int;
    final resp = await EdgService().setPartialPayment(
      customAmount: customAmount!,
      billAmount: billAmt,
      phoneNumber: phoneNumber ?? '',
    );
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      amount = (data['amount'] as num?)?.toInt();
      step = data['next_step']?.toString() ?? 'confirm';
      notifyListeners();
    }
    return resp;
  }

  Future<Map<String, dynamic>?> setAmountAction() async {
    if (amount == null) return null;
    final resp = await EdgService().setAmount(amount: amount!, phoneNumber: phoneNumber ?? '');
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      amount = (data['amount'] as num?)?.toInt();
      step = data['next_step']?.toString() ?? 'confirm';
      notifyListeners();
    }
    return resp;
  }

  Future<Map<String, dynamic>?> goBack() async {
    final resp = await EdgService().goBack(
      currentStep: step,
      customerType: customerType,
      selectedBill: selectedBill?['code'] as String?,
    );
    if (resp != null && resp['success'] == true) {
      final data = resp['data'] as Map<String, dynamic>;
      final next = data['next_step']?.toString() ?? step;
      step = next;
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
      notifyListeners();
    }
    return resp;
  }

  Future<void> resetForm() async {
    final resp = await EdgService().resetForm();
    final data = (resp != null && resp['success'] == true)
        ? (resp['data'] as Map<String, dynamic>?)
        : null;
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
    notifyListeners();
  }
}


