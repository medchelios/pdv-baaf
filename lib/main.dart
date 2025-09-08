import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/payment_type_screen.dart';
import 'screens/prepaid_payment_screen.dart';
import 'screens/postpaid_payment_screen.dart';

void main() {
  runApp(const PdvBaafApp());
}

class PdvBaafApp extends StatelessWidget {
  const PdvBaafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDV Baaf',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/payment-type': (context) => const PaymentTypeScreen(),
        '/prepaid-payment': (context) => const PrepaidPaymentScreen(),
        '/postpaid-payment': (context) => const PostpaidPaymentScreen(),
      },
    );
  }
}