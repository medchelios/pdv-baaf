import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../services/auth_service.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user;
    final userName = user?['name'] ?? 'Agent PDV';
    final roleLabel = (user?['role_label'] ?? user?['role'] ?? '').toString();
    final phone = (user?['phone'] ?? user?['telephone'] ?? '').toString();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.brandBlue,
            Color(0xFF0e4b5b),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour $userName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (roleLabel.isNotEmpty || phone.isNotEmpty)
                    Text(
                      [roleLabel, phone].where((e) => e.isNotEmpty).join(' • '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                _HeaderIconButton(icon: Icons.notifications_rounded),
                const SizedBox(width: 12),
                _HeaderIconButton(icon: Icons.analytics_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  const _HeaderIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
