import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class QuickActionsSection extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsSection({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions Rapides',
            style: AppConstants.heading3,
          ),
          const SizedBox(height: AppConstants.paddingM),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppConstants.paddingM,
              mainAxisSpacing: AppConstants.paddingM,
              childAspectRatio: 1.2,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionCard(action);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 24,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              action.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
