import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/mobile/agent';
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Authentification
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headers,
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de déconnexion: $e',
      };
    }
  }

  // Paiements
  Future<Map<String, dynamic>> processPayment({
    required String customerPhone,
    required String invoiceReference,
    required double amount,
    required String paymentMethod,
    required String customerName,
    required String customerReference,
    required String customerType,
    String? billCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/process'),
        headers: _headers,
        body: jsonEncode({
          'customer_phone': customerPhone,
          'invoice_reference': invoiceReference,
          'amount': amount,
          'payment_method': paymentMethod,
          'customer_name': customerName,
          'customer_reference': customerReference,
          'customer_type': customerType,
          if (billCode != null) 'bill_code': billCode,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors du paiement: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getPaymentHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/history'),
        headers: _headers,
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la récupération de l\'historique: $e',
      };
    }
  }

  // Factures
  Future<Map<String, dynamic>> searchInvoices(String reference) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoices/search?reference=$reference'),
        headers: _headers,
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la recherche de factures: $e',
      };
    }
  }

  Future<Map<String, dynamic>> payInvoiceForCustomer(String invoiceId, {
    required String customerPhone,
    required String customerName,
    required String paymentMethod,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/invoices/$invoiceId/pay-for-customer'),
        headers: _headers,
        body: jsonEncode({
          'customer_phone': customerPhone,
          'customer_name': customerName,
          'payment_method': paymentMethod,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors du paiement de la facture: $e',
      };
    }
  }
}
