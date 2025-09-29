import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'pin_login_screen.dart';

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

              // Logo BAAF
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choisissez une méthode de connexion',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

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

                  const SizedBox(height: 16),

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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
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
