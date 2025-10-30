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
      LoggerService.debug('EDG getCustomerBills: POST $url');
      LoggerService.debug('EDG getCustomerBills payload: {"customer_ref": "$customerRef"}');
      
      final res = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: json.encode({'customer_ref': customerRef}),
      );
      
      LoggerService.debug('EDG getCustomerBills response: ${res.statusCode} ${res.body}');
      
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        LoggerService.debug('EDG getCustomerBills success: $data');
        return data;
      }
      
      LoggerService.warning('EDG getCustomerBills error: ${res.statusCode} ${res.body}');
      try {
        final errorData = json.decode(res.body) as Map<String, dynamic>;
        return {
          'success': false,
          'error': errorData['error'] ?? errorData['message'] ?? 'Erreur ${res.statusCode}',
        };
      } catch (_) {
        return {
          'success': false,
          'error': 'Erreur ${res.statusCode}: ${res.body}',
        };
      }
    } catch (e) {
      LoggerService.error('EDG getCustomerBills exception', e);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>?> getBillDetails(String billCode) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/get-bill-details');
    try {
      LoggerService.debug('EDG getBillDetails: POST $url');
      LoggerService.debug('EDG getBillDetails payload: {"bill_code": "$billCode"}');
      
      final res = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: json.encode({'bill_code': billCode}),
      );
      
      LoggerService.debug('EDG getBillDetails response: ${res.statusCode} ${res.body}');
      
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        LoggerService.debug('EDG getBillDetails success: $data');
        return data;
      }
      
      LoggerService.warning('EDG getBillDetails error: ${res.statusCode} ${res.body}');
      try {
        final errorData = json.decode(res.body) as Map<String, dynamic>;
        return {
          'success': false,
          'error': errorData['error'] ?? errorData['message'] ?? 'Erreur ${res.statusCode}',
        };
      } catch (_) {
        return {
          'success': false,
          'error': 'Erreur ${res.statusCode}: ${res.body}',
        };
      }
    } catch (e) {
      LoggerService.error('EDG getBillDetails exception', e);
      return {
        'success': false,
        'error': e.toString(),
      };
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
    final url = Uri.parse('${ApiConfig.paymentsUrl}/process');
    try {
      final payload = {
        'customer_type': customerType,
        'amount': amount,
        'phone_number': phone,
        if (customerReference != null) 'subscriber_reference': customerReference,
        if (customerReference != null) 'customer_reference': customerReference,
        if (customerName != null) 'customer_name': customerName,
        if (billCode != null) 'bill_code': billCode,
        if (billDate != null) 'bill_date': billDate,
      };
      LoggerService.debug('EDG processAgentPayment: POST $url');
      LoggerService.debug('EDG processAgentPayment payload: $payload');
      LoggerService.debug('EDG processAgentPayment headers: ${_authHeaders.keys}');
      
      final res = await http.post(
        url,
        headers: _authHeaders,
        body: json.encode(payload),
      );
      
      LoggerService.debug('EDG processAgentPayment response: ${res.statusCode} ${res.body}');
      
      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = json.decode(res.body) as Map<String, dynamic>;
        LoggerService.debug('EDG processAgentPayment success: $responseData');
        return responseData;
      }
      
      LoggerService.warning('EDG processAgentPayment error: ${res.statusCode} ${res.body}');
      return {
        'success': false,
        'error': 'Erreur ${res.statusCode}: ${res.body}',
      };
    } catch (e) {
      LoggerService.error('EDG processAgentPayment exception', e);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}


