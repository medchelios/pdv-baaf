import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/common/balance_card.dart';
import '../widgets/common/quick_action_grid.dart';
import '../widgets/common/custom_card.dart';
import '../controllers/stats_controller.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';
import 'payment_type_screen.dart';
import 'prepaid_payment_screen.dart';
import 'postpaid_payment_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatsController()..loadAllStats(),
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            _HomePage(),
            PaymentTypeScreen(),
            _UvPage(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec salutation
              _buildHeader(context),
              
              const SizedBox(height: AppConstants.paddingXL),
              
              // Carte de balance
              _buildBalanceCard(context),
              
              const SizedBox(height: AppConstants.paddingXL),
              
              // Actions rapides
              _buildQuickActions(context),
              
              const SizedBox(height: AppConstants.paddingXL),
              
              // Statistiques
              _buildStatsSection(context),
              
              const SizedBox(height: AppConstants.paddingXL),
              
              // Transactions récentes
              _buildRecentTransactions(context),
              
              const SizedBox(height: 100), // Espace pour la navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userName = AuthService().user?['name']?.split(' ').first ?? 'Agent';
    final now = DateTime.now();
    final dayNames = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final monthNames = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, $userName!',
                style: AppConstants.heading1,
              ),
              const SizedBox(height: AppConstants.paddingXS),
              Text(
                '${dayNames[now.weekday - 1]}, ${now.day} ${monthNames[now.month - 1]} ${now.year}',
                style: AppConstants.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM, vertical: AppConstants.paddingS),
          decoration: BoxDecoration(
            color: AppConstants.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          child: const Text(
            'GNF',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppConstants.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Consumer<StatsController>(
      builder: (context, statsController, child) {
        final amount = statsController.formatAmount(statsController.todayAmount);
        
        return BalanceCard(
          title: 'Solde Disponible',
          amount: amount,
          subtitle: 'Aujourd\'hui',
          primaryColor: AppConstants.primaryBlue,
          secondaryColor: AppConstants.primaryOrange,
          actions: [
            Expanded(
              child: _buildActionButton(
                context,
                title: 'Envoyer',
                icon: Icons.send_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrepaidPaymentScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: _buildActionButton(
                context,
                title: 'Recevoir',
                icon: Icons.request_quote_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostpaidPaymentScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: AppConstants.heading3,
        ),
        const SizedBox(height: AppConstants.paddingM),
        QuickActionGrid(
          actions: [
            QuickAction(
              title: 'Prépayé',
              icon: Icons.payment_rounded,
              color: AppConstants.primaryOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrepaidPaymentScreen(),
                  ),
                );
              },
            ),
            QuickAction(
              title: 'Postpayé',
              icon: Icons.receipt_long_rounded,
              color: AppConstants.primaryBlue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostpaidPaymentScreen(),
                  ),
                );
              },
            ),
            QuickAction(
              title: 'Historique',
              icon: Icons.history_rounded,
              color: AppConstants.successColor,
              onTap: () {
                // TODO: Implémenter l'historique
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Consumer<StatsController>(
      builder: (context, statsController, child) {
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aujourd\'hui',
                style: AppConstants.heading3,
              ),
              const SizedBox(height: AppConstants.paddingM),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Paiements',
                      '${statsController.todayPayments}',
                      Icons.payment_rounded,
                      AppConstants.primaryOrange,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppConstants.textLight.withValues(alpha: 0.3),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Montant',
                      statsController.formatAmount(statsController.todayAmount),
                      Icons.attach_money_rounded,
                      AppConstants.primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: AppConstants.paddingS),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: AppConstants.paddingXS),
        Text(
          label,
          style: AppConstants.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions Récentes',
              style: AppConstants.heading3,
            ),
            TextButton(
              onPressed: () {
                // TODO: Implémenter la page d'historique
              },
              child: const Text(
                'Voir tout',
                style: TextStyle(
                  color: AppConstants.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        CustomCard(
          child: Column(
            children: [
              _buildTransactionItem(
                'Paiement Électricité',
                'Aujourd\'hui 10h',
                '+2,847.50 GNF',
                Icons.receipt_long_rounded,
                AppConstants.successColor,
              ),
              const Divider(height: AppConstants.paddingXL),
              _buildTransactionItem(
                'Recharge Prépayé',
                'Hier 15h',
                '+1,500.00 GNF',
                Icons.payment_rounded,
                AppConstants.primaryOrange,
              ),
              const Divider(height: AppConstants.paddingXL),
              _buildTransactionItem(
                'Paiement Facture',
                '12 Juillet',
                '+3,200.00 GNF',
                Icons.receipt_rounded,
                AppConstants.primaryBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String time, String amount, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppConstants.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppConstants.bodyLarge,
              ),
              const SizedBox(height: AppConstants.paddingXS),
              Text(
                time,
                style: AppConstants.bodySmall,
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _UvPage extends StatelessWidget {
  const _UvPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCard(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 40,
                        color: AppConstants.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXL),
                    Text(
                      'Fonctionnalité UV',
                      style: AppConstants.heading2,
                    ),
                    const SizedBox(height: AppConstants.paddingS),
                    Text(
                      'Bientôt disponible',
                      style: AppConstants.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}