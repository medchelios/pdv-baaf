import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'pin_login_screen.dart';
import '../widgets/auth/auth_logo.dart';
import '../widgets/auth/auth_subtitle.dart';

class AuthTypeScreen extends StatelessWidget {
  const AuthTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),

              const AuthLogo(),

              const SizedBox(height: 28),

              const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 8),

              const AuthSubtitle(text: 'Choisissez une méthode de connexion'),

              const SizedBox(height: 36),

              // Boutons de connexion
              Column(
                children: [
                  // Connexion PDV
                  _buildAuthButton(
                    context,
                    icon: Icons.key_rounded,
                    title: 'Code PDV',
                    subtitle: 'Saisissez votre code PDV (8 chiffres)',
                    color: const Color(0xFFe94d29),
                    buttonKey: const Key('auth_pdv_button'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PinLoginScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Connexion Standard
                  _buildAuthButton(
                    context,
                    icon: Icons.mail_lock_rounded,
                    title: 'Email et mot de passe',
                    subtitle: 'Connexion classique et sécurisée',
                    color: const Color(0xFF0e4b5b),
                    buttonKey: const Key('auth_email_button'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),

              // Footer
              const Text(
                'BAAF - Version 1.0',
                style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Key? buttonKey,
    required VoidCallback onTap,
  }) {
    return Material(
      key: buttonKey,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
