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
    return token != null ? ApiConfig.getAuthHeaders(token) : ApiConfig.defaultHeaders;
  }

  Future<Map<String, dynamic>?> getCustomerBills(String customerRef) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/get-customer-bills');
    try {
      LoggerService.debug('EDG getCustomerBills: $customerRef');
      final res = await http.post(url, headers: ApiConfig.defaultHeaders, body: json.encode({'customer_ref': customerRef}));
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      LoggerService.warning('EDG getCustomerBills error: ${res.statusCode} ${res.body}');
      return null;
    } catch (e) {
      LoggerService.error('EDG getCustomerBills exception', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBillDetails(String billCode) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/get-bill-details');
    try {
      LoggerService.debug('EDG getBillDetails: $billCode');
      final res = await http.post(url, headers: ApiConfig.defaultHeaders, body: json.encode({'bill_code': billCode}));
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      LoggerService.warning('EDG getBillDetails error: ${res.statusCode} ${res.body}');
      return null;
    } catch (e) {
      LoggerService.error('EDG getBillDetails exception', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> processAgentPayment({
    required String customerType, // 'prepaid' | 'postpaid'
    String? customerReference, // meter or customer reference
    String? billCode, // for postpaid
    required int amount,
    required String phone,
  }) async {
    final url = Uri.parse('${ApiConfig.paymentsUrl}/process');
    try {
      final payload = {
        'customer_type': customerType,
        if (customerReference != null) 'subscriber_reference': customerReference,
        if (billCode != null) 'bill_code': billCode,
        'amount': amount,
        'phone_number': phone,
      };
      LoggerService.debug('EDG processAgentPayment: $payload');
      final res = await http.post(url, headers: _authHeaders, body: json.encode(payload));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
      LoggerService.warning('EDG processAgentPayment error: ${res.statusCode} ${res.body}');
      return null;
    } catch (e) {
      LoggerService.error('EDG processAgentPayment exception', e);
      return null;
    }
  }
}


