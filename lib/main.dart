import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_type_screen.dart';
import 'screens/login_screen.dart';
import 'screens/pin_login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/uv_orders/uv_orders_screen.dart';
import 'screens/uv_orders/orders_history_screen.dart';
import 'screens/accounts/account_transfer_screen.dart';
import 'screens/payments/recent_payments_screen.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/user_data_service.dart';
import 'controllers/dashboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().initialize();
  await UserDataService().initialize();
  runApp(const PdvBaafApp());
}

class PdvBaafApp extends StatelessWidget {
  const PdvBaafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DashboardController())],
      child: MaterialApp(
        title: 'Baaf',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthTypeScreen(),
        routes: {
          '/auth-type': (context) => const AuthTypeScreen(),
          '/login': (context) => const LoginScreen(),
          '/pin-login': (context) => const PinLoginScreen(),
          '/home': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            final initialIndex = args is int ? args : 0;
            return HomeScreen(initialIndex: initialIndex);
          },
          '/dashboard': (context) => const DashboardScreen(),
          '/uv-orders': (context) => const UVOrdersScreen(),
          '/uv-orders/history': (context) => const OrdersHistoryScreen(),
          '/payments': (context) => const HomeScreen(initialIndex: 1),
          '/uv': (context) => const HomeScreen(initialIndex: 2),
          '/accounts/transfer': (context) => const AccountTransferScreen(),
          '/payments/recent': (context) => const RecentPaymentsScreen(),
        },
      ),
    );
  }
}
