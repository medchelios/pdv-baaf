import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';
import 'logger_service.dart';

class EdgService {
  static final EdgService _instance = EdgService._internal();
  factory EdgService() => _instance;
  EdgService._internal();

  Map<String, String> get _authHeaders {
    final token = AuthService().token;
    return token != null
        ? ApiConfig.getAuthHeaders(token)
        : ApiConfig.defaultHeaders;
  }

  Future<Map<String, dynamic>?> getCustomerBills(String customerRef) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/get-customer-bills');
    try {
      LoggerService.debug('EDG getCustomerBills: POST $url');
      LoggerService.debug(
        'EDG getCustomerBills payload: {"customer_ref": "$customerRef"}',
      );

      final res = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: json.encode({'customer_ref': customerRef}),
      );

      LoggerService.debug(
        'EDG getCustomerBills response: ${res.statusCode} ${res.body}',
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        LoggerService.debug('EDG getCustomerBills success: $data');
        return data;
      }

      LoggerService.warning(
        'EDG getCustomerBills error: ${res.statusCode} ${res.body}',
      );
      try {
        final errorData = json.decode(res.body) as Map<String, dynamic>;
        return {
          'success': false,
          'error':
              errorData['error'] ??
              errorData['message'] ??
              'Erreur ${res.statusCode}',
        };
      } catch (_) {
        return {
          'success': false,
          'error': 'Erreur ${res.statusCode}: ${res.body}',
        };
      }
    } catch (e) {
      LoggerService.error('EDG getCustomerBills exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> getBillDetails(String billCode) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/get-bill-details');
    try {
      LoggerService.debug('EDG getBillDetails: POST $url');
      LoggerService.debug(
        'EDG getBillDetails payload: {"bill_code": "$billCode"}',
      );

      final res = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: json.encode({'bill_code': billCode}),
      );

      LoggerService.debug(
        'EDG getBillDetails response: ${res.statusCode} ${res.body}',
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        LoggerService.debug('EDG getBillDetails success: $data');
        return data;
      }

      LoggerService.warning(
        'EDG getBillDetails error: ${res.statusCode} ${res.body}',
      );
      try {
        final errorData = json.decode(res.body) as Map<String, dynamic>;
        return {
          'success': false,
          'error':
              errorData['error'] ??
              errorData['message'] ??
              'Erreur ${res.statusCode}',
        };
      } catch (_) {
        return {
          'success': false,
          'error': 'Erreur ${res.statusCode}: ${res.body}',
        };
      }
    } catch (e) {
      LoggerService.error('EDG getBillDetails exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> processAgentPayment({
    required String customerType, // 'prepaid' | 'postpaid'
    String? customerReference, // meter or customer reference
    String? customerName, // customer name
    String? billCode, // for postpaid
    String? billDate, // for postpaid
    required int amount,
    required String phone,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/process');
    try {
      final payload = {
        'customer_type': customerType,
        'amount': amount,
        'phone_number': phone,
        if (customerReference != null)
          'subscriber_reference': customerReference,
        if (customerReference != null) 'customer_reference': customerReference,
        if (customerName != null) 'customer_name': customerName,
        if (billCode != null) 'bill_code': billCode,
        if (billDate != null) 'bill_date': billDate,
      };
      LoggerService.debug('EDG processAgentPayment: POST $url');
      LoggerService.debug('EDG processAgentPayment payload: $payload');
      LoggerService.debug(
        'EDG processAgentPayment headers: ${_authHeaders.keys}',
      );

      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );

      LoggerService.debug(
        'EDG processAgentPayment response: ${res.statusCode} ${res.body}',
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = json.decode(res.body) as Map<String, dynamic>;
        LoggerService.debug('EDG processAgentPayment success: $responseData');
        return responseData;
      }

      LoggerService.warning(
        'EDG processAgentPayment error: ${res.statusCode} ${res.body}',
      );
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG processAgentPayment exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }
}

extension EdgWorkflowApi on EdgService {
  Future<Map<String, dynamic>?> selectType({
    required String customerType,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/select-type');
    try {
      final payload = {'customer_type': customerType};
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG selectType exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> validateCustomer({
    required String customerType,
    required String customerReference,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/validate-customer');
    try {
      final payload = {
        'customer_type': customerType,
        'customer_reference': customerReference,
      };
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG validateCustomer exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> selectBill({
    required List<Map<String, dynamic>> bills,
    required String billCode,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/select-bill');
    try {
      final payload = {'bills': bills, 'bill_code': billCode};
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG selectBill exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> validatePhone({
    required String phoneNumber,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/validate-phone');
    try {
      final payload = {'phone_number': phoneNumber};
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG validatePhone exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> setFullPayment({
    required int billAmount,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/set-full-payment');
    try {
      final payload = {'bill_amount': billAmount, 'phone_number': phoneNumber};
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG setFullPayment exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> setPartialPayment({
    required int customAmount,
    required int billAmount,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/set-partial-payment');
    try {
      final payload = {
        'custom_amount': customAmount,
        'bill_amount': billAmount,
        'phone_number': phoneNumber,
      };
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG setPartialPayment exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> setAmount({
    required int amount,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/set-amount');
    try {
      final payload = {'amount': amount, 'phone_number': phoneNumber};
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG setAmount exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> goBack({
    required String currentStep,
    String? customerType,
    String? selectedBill,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/go-back');
    try {
      final payload = {
        'current_step': currentStep,
        if (customerType != null) 'customer_type': customerType,
        if (selectedBill != null) 'selected_bill': selectedBill,
      };
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG goBack exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> resetForm() async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/edg/reset-form');
    try {
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode({}),
      );
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG resetForm exception', e);
      return {'success': false, 'error': e.toString()};
    }
  }
}
