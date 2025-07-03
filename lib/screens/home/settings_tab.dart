import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'card_field_test_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userName = user?.name ?? 'Nicolas Adams';
    final userEmail = user?.email ?? 'nicolasadams@gmail.com';
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.grey[800],
                        child: Icon(Icons.person, size: 56, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.yellow,
                          child: Icon(Icons.edit, size: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Settings options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _SettingsTile(icon: Icons.privacy_tip_outlined, label: 'Privacy', onTap: () {}),
                  _SettingsTile(icon: Icons.history, label: 'Purchase History', onTap: () {}),
                  _SettingsTile(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
                  _SettingsTile(icon: Icons.settings, label: 'Settings', onTap: () {}),
                  _SettingsTile(icon: Icons.person_add_alt, label: 'Invite a Friend', onTap: () {}),
                  const SizedBox(height: 24),
                  // Terms & Conditions Section
                  const Text('Terms & Conditions', style: TextStyle(color: Color(0xFFB388FF), fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  _SettingsTile(icon: Icons.policy, label: 'Purchase Policy', onTap: () {}),
                  _SettingsTile(icon: Icons.privacy_tip, label: 'Privacy Policy', onTap: () {}),
                  _SettingsTile(icon: Icons.money_off, label: 'Refund Policy', onTap: () {}),
                  _SettingsTile(icon: Icons.cookie, label: 'Cookie Policy', onTap: () {}),
                  const SizedBox(height: 32),
                  // Logout Button
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onTap: () async {
                      await Provider.of<AuthProvider>(context, listen: false).logout();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    tileColor: Colors.grey[900],
                  ),
                  const SizedBox(height: 24),
                  // CardField Test Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CardFieldTestScreen()),
                      );
                    },
                    child: const Text('Test CardField'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: Colors.grey[900],
      ),
    );
  }
} 