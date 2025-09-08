import 'package:flutter/material.dart';
import 'screens/auth_type_screen.dart';
import 'screens/login_screen.dart';
import 'screens/pin_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/payment_type_screen.dart';
import 'screens/prepaid_payment_screen.dart';
import 'screens/postpaid_payment_screen.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().initialize();
  runApp(const PdvBaafApp());
}

class PdvBaafApp extends StatelessWidget {
  const PdvBaafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDV Baaf',
      theme: AppTheme.lightTheme,
      home: const AuthTypeScreen(),
      routes: {
        '/auth-type': (context) => const AuthTypeScreen(),
        '/login': (context) => const LoginScreen(),
        '/pin-login': (context) => const PinLoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/payment-type': (context) => const PaymentTypeScreen(),
        '/prepaid-payment': (context) => const PrepaidPaymentScreen(),
        '/postpaid-payment': (context) => const PostpaidPaymentScreen(),
      },
    );
  }
}