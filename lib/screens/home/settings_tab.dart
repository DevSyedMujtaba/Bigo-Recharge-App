import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'card_field_test_screen.dart';
import 'order_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'webview_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userName = user?.name ?? '';
    final userEmail = user?.email ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFF18192A),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.grey[800],
                        child: Icon(Icons.person, size: 56, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      user != null
                          ? Column(
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userEmail,
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8F5CF7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed('/login');
                                  },
                                  child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 14)),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _SettingsTile(
                      icon: Icons.receipt_long,
                      label: 'Orders',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const OrderScreen()),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.info_outline,
                    label: 'About Us',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'About Us',
                            url: '\u001b[BASE_URL]/about-us'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.help_outline,
                    label: 'FAQ',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'FAQ',
                            url: '\u001b[BASE_URL]/faq'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.article,
                    label: 'Terms & Conditions',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'Terms & Conditions',
                            url: '\u001b[BASE_URL]/terms-conditions'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.policy,
                    label: 'Purchase Policy',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'Purchase Policy',
                            url: '\u001b[BASE_URL]/purchase-policy'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.privacy_tip,
                    label: 'Privacy Policy',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'Privacy Policy',
                            url: '\u001b[BASE_URL]/privacy-policy'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.money_off,
                    label: 'Refund Policy',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'Refund Policy',
                            url: '\u001b[BASE_URL]/refund-policy'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SettingsTile(
                    icon: Icons.cookie,
                    label: 'Cookie Policy',
                    onTap: () {
                      final baseUrl = dotenv.env['BASE_URL'] ?? '';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(
                            title: 'Cookie Policy',
                            url: '\u001b[BASE_URL]/cookie-policy'.replaceFirst('\u001b[BASE_URL]', baseUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Color(0xFF8F5CF7)),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFF8F5CF7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tileColor: Colors.grey[900],
                    ),
                  ),
              ]),
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
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white38,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: Colors.grey[900],
      ),
    );
  }
}
