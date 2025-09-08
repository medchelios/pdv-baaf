import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dashboard_controller.dart';
import '../constants/app_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<DashboardController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  Text(
                    'Erreur de chargement',
                    style: AppConstants.heading3,
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    controller.error!,
                    style: AppConstants.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  ElevatedButton(
                    onPressed: () => controller.loadDashboardData(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats UV
                _buildSection(
                  'Commandes UV',
                  [
                    _buildStatItem('Total', '25', AppConstants.primaryBlue),
                    _buildStatItem('En attente', '5', AppConstants.warningColor),
                    _buildStatItem('Validées', '18', AppConstants.successColor),
                    _buildStatItem('Rejetées', '2', AppConstants.errorColor),
                  ],
                ),
                
                const SizedBox(height: AppConstants.paddingXL),
                
                // Stats Paiements
                _buildSection(
                  'Paiements',
                  [
                    _buildStatItem('Total', '4', AppConstants.primaryBlue),
                    _buildStatItem('Réussis', '4', AppConstants.successColor),
                    _buildStatItem('Échoués', '0', AppConstants.errorColor),
                    _buildStatItem('Montant', '425K GNF', AppConstants.primaryOrange),
                  ],
                ),
                
                const SizedBox(height: AppConstants.paddingXL),
                
                // Paiements récents
                _buildRecentPayments(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppConstants.heading2),
        const SizedBox(height: AppConstants.paddingM),
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            boxShadow: AppConstants.cardShadow,
          ),
          child: Column(
            children: stats,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppConstants.bodyMedium),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPayments(DashboardController controller) {
    final payments = controller.recentPayments;
    if (payments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Paiements Récents', style: AppConstants.heading2),
        const SizedBox(height: AppConstants.paddingM),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            boxShadow: AppConstants.cardShadow,
          ),
          child: Column(
            children: payments.map((payment) {
              return _buildPaymentItem(controller, payment);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentItem(DashboardController controller, Map<String, dynamic> payment) {
    final isLast = payment == controller.recentPayments.last;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: AppConstants.textLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.payment_rounded,
              color: AppConstants.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['customer_name'],
                  style: AppConstants.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '${payment['reference']} • ${controller.getPaymentMethodLabel(payment['method'])}',
                  style: AppConstants.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.formatAmount(payment['amount'].toDouble()),
                style: AppConstants.bodyLarge,
              ),
              const SizedBox(height: 2),
              Text(
                controller.getStatusLabel(payment['status']),
                style: AppConstants.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}