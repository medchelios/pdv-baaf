import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: const Color(0xFF0e4b5b),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profil utilisateur
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFe94d29).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFe94d29),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthService().user?['name'] ?? 'Utilisateur',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0e4b5b),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AuthService().user?['email'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          AuthService().user?['role'] ?? 'Agent',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Options
          _buildSettingsSection(
            'Compte',
            [
              _buildSettingsItem(
                icon: Icons.person_outline,
                title: 'Profil',
                subtitle: 'Informations personnelles',
                onTap: () {
                  // TODO: Implémenter la page de profil
                },
              ),
              _buildSettingsItem(
                icon: Icons.security_outlined,
                title: 'Sécurité',
                subtitle: 'Mot de passe et sécurité',
                onTap: () {
                  // TODO: Implémenter la page de sécurité
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSettingsSection(
            'Application',
            [
              _buildSettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Gérer les notifications',
                onTap: () {
                  // TODO: Implémenter la page de notifications
                },
              ),
              _buildSettingsItem(
                icon: Icons.language_outlined,
                title: 'Langue',
                subtitle: 'Français',
                onTap: () {
                  // TODO: Implémenter le changement de langue
                },
              ),
              _buildSettingsItem(
                icon: Icons.help_outline,
                title: 'Aide',
                subtitle: 'Support et FAQ',
                onTap: () {
                  // TODO: Implémenter la page d'aide
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSettingsSection(
            'Système',
            [
              _buildSettingsItem(
                icon: Icons.info_outline,
                title: 'À propos',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  // TODO: Implémenter la page à propos
                },
              ),
              _buildSettingsItem(
                icon: Icons.logout,
                title: 'Déconnexion',
                subtitle: 'Se déconnecter de l\'application',
                onTap: () async {
                  await _showLogoutDialog(context);
                },
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0e4b5b),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive 
              ? const Color(0xFFEF4444).withValues(alpha: 0.1)
              : const Color(0xFFe94d29).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFFe94d29),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF0e4b5b),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF6B7280),
      ),
      onTap: onTap,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Déconnexion',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/auth-type');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
