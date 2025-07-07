import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'card_field_test_screen.dart';
import 'order_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'webview_screen.dart';
import '../../screens/auth/login_screen.dart';

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
                        child: Icon(
                          Icons.person,
                          size: 56,
                          color: Colors.white,
                        ),
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
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48.0,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEC4899),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
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
                          MaterialPageRoute(
                            builder: (_) => const OrderScreen(),
                          ),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AboutUsScreen(),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FAQScreen()),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TermsAndConditionsScreen(),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PurchasePolicyScreen(),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RefundPolicyScreen(),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CookiePolicyScreen(),
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
                      leading: const Icon(
                        Icons.logout,
                        color: Color(0xFFEC4899),
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFFEC4899),
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

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Website Terms and Conditions of Use',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              '1. Agreement to Terms',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'By accessing this website, available at https://www.diamondstopup.com, you agree to comply with these Terms and Conditions of Use and acknowledge that you are responsible for following any applicable local laws. If you do not agree with any part of these terms, you are not permitted to use this website. All content and materials on this site are protected by copyright and trademark laws.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Limited License',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Dimond TOP UP grants you permission to temporarily download one copy of the materials on this website for your personal, non-commercial, and transitory viewing only. This is a license, not a transfer of ownership. Under this license, you may not:',
            ),
            SizedBox(height: 8),
            Text(
              '• modify or copy the materials;\n• use the materials for any commercial purpose or public display;\n• attempt to reverse engineer any software on the website;\n• remove any copyright or proprietary notices; or\n• share or mirror the materials on any other server.\nIf you violate any of these restrictions, this license will automatically terminate. Upon termination, you must delete or destroy any downloaded materials in any format.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Disclaimer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'All materials on Dimond TOP UP\'s website are provided "as is." Dimond TOP UP makes no warranties, express or implied, and hereby disclaims all other warranties, including implied warranties of merchantability or fitness for a particular purpose. Dimond TOP UP does not guarantee the accuracy, completeness, or reliability of any materials on this website or any linked websites.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Limitation of Liability',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'In no event shall Dimond TOP UP or its suppliers be liable for any damages arising from your use of or inability to use the materials on this website, even if Dimond TOP UP or an authorized representative has been advised of the possibility of such damages. Some jurisdictions do not allow limitations on implied warranties or the exclusion of liability for certain damages, so these limitations may not apply to you.',
            ),
            SizedBox(height: 16),
            Text(
              'This text is a sample Terms & Conditions template. For legal compliance and to protect your business, you should consult a qualified attorney to create or review your official Terms and Conditions.',
            ),
          ],
        ),
      ),
    );
  }
}

class PurchasePolicyScreen extends StatelessWidget {
  const PurchasePolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Purchase Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'How to Purchase Diamonds and Our Important Policies',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'How to Buy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              '1. Choose Your Package: Explore our range of Diamond packages on the Products page or Homepage.',
            ),
            Text(
              '2. Add to Cart: Click "Add to Cart" for your selected package. You can update the quantity in your cart before checking out.',
            ),
            Text(
              '3. Enter Your User ID: At checkout, you must enter your correct User ID. Please ensure this ID is accurate, as your Diamonds will be delivered to the ID you provide.',
            ),
            Text(
              '4. Checkout & Payment: Proceed to checkout and enter your payment and billing details. All payments are processed securely via trusted payment gateways.',
            ),
            Text(
              '5. Order Confirmation: Once your payment is successful, you will receive an order confirmation on our website and by email.',
            ),
            Text(
              '6. Diamond Delivery: Diamonds will be credited to the provided User ID, usually within a few minutes.',
            ),
            SizedBox(height: 16),
            Text(
              'Important Policies',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              '• Accurate User ID: You are solely responsible for entering the correct User ID. We cannot offer refunds or reprocess transactions sent to an incorrect ID due to customer error.',
            ),
            Text(
              '• Digital Goods Policy: Diamonds are digital items. Once delivered, they are non-returnable and non-refundable, except in cases specified in our Refund Policy.',
            ),
            Text(
              '• Processing Times: Most orders are completed instantly. During busy periods or for larger orders, please allow up to 30 minutes. If your Diamonds have not arrived after this time, please contact our support team.',
            ),
            Text(
              '• Pricing: All prices are shown in your regional currency (e.g., GBP for UK customers, USD elsewhere) and may change without prior notice. The price charged will be the price displayed at the time of your purchase.',
            ),
            Text(
              '• Account Security: You are responsible for maintaining the security and access to your account.',
            ),
            Text(
              '• Service Availability: We strive to maintain 24/7 service, but uninterrupted availability cannot be guaranteed.',
            ),
            SizedBox(height: 16),
            Text(
              'Dispute Resolution',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'If you experience any problems with your purchase, please contact our Customer Support team first. We are committed to resolving all issues promptly and fairly. For more information, please refer to our Terms & Conditions.',
            ),
            SizedBox(height: 16),
            Text(
              'Please read and understand these policies before completing a purchase. By placing an order, you agree to these terms. For any questions, feel free to reach out to us.',
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Protecting Your Privacy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Diamond Top Up (“we,” “us,” or “our”) operates the https://www.diamondstopup.com website (the “Service”). This policy explains how we collect, use, and protect your personal information when you use our Service, as well as your rights regarding that information.',
            ),
            SizedBox(height: 8),
            Text(
              'By accessing or using the Service, you agree to the collection and use of your data as described in this policy.',
            ),
            SizedBox(height: 16),
            Text(
              'Information We Collect',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'To provide you with the best experience, we may collect different types of information, including:',
            ),
            Text(
              '• Contact Details: such as your email address, first and last name',
            ),
            Text(
              '• Payment Information: processed securely through third-party payment providers (we do not store your payment details ourselves)',
            ),
            Text(
              '• Usage Data: information about how you use and interact with the Service',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text('We use the data we collect for purposes such as:'),
            Text('• Delivering and maintaining the Service'),
            Text('• Processing and confirming your purchases'),
            Text(
              '• Notifying you about updates, changes, or important information',
            ),
            Text('• Enabling interactive features you choose to use'),
            Text('• Providing customer support and assistance'),
            Text(
              '• Analyzing how the Service is used to improve our offerings',
            ),
            Text('• Preventing and addressing technical issues or misuse'),
            SizedBox(height: 16),
            Text(
              'Data Security',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'We take the security of your information seriously. While no method of transmission over the Internet or electronic storage is completely secure, we use commercially reasonable measures to protect your personal data. However, we cannot guarantee its absolute security.',
            ),
            SizedBox(height: 16),
            Text(
              'Important Notice',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'This page provides a basic overview of our privacy practices. It is a placeholder policy. To fully comply with applicable laws and regulations (such as GDPR or CCPA), please ensure you replace this with a comprehensive privacy policy that includes details about:',
            ),
            Text('• Data retention'),
            Text('• Cookies and tracking technologies'),
            Text('• User rights (e.g., access, correction, deletion)'),
            Text('• How to exercise those rights'),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'If you have any questions about this Privacy Policy or how we handle your data, please contact us at: support@diamondstopup.com',
            ),
          ],
        ),
      ),
    );
  }
}

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Refund Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Diamond Top Up – How Refunds Work',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Overview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'At Diamond Top Up, we aim to deliver a reliable and satisfying experience every time you purchase Diamonds. Because these are digital goods that are delivered immediately, all sales are generally considered final.',
            ),
            SizedBox(height: 16),
            Text(
              'Non-Refundable Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Once your Diamonds have been successfully delivered to your account or email, your purchase is non-refundable and non-returnable. Tip: Always double-check your User ID and order details before you complete payment, as we cannot reverse transactions sent to the wrong account.',
            ),
            SizedBox(height: 16),
            Text(
              'When Refunds May Be Considered',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'While refunds are not typically issued, we may review refund or replacement requests in these specific situations:',
            ),
            Text(
              '• There was a clear technical error on our side that prevented your Diamonds from being delivered.',
            ),
            Text(
              '• Your order was affected by proven fraudulent activity not caused by customer error.',
            ),
            Text(
              'Please note: Refunds in these cases are not guaranteed and will be assessed individually at our discretion.',
            ),
            SizedBox(height: 16),
            Text(
              'Requesting a Refund',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'If you believe you qualify for a refund, please follow these steps:',
            ),
            Text('Contact our support team at:'),
            Text('Email: support@diamondstopup.com'),
            Text('Include all relevant information:'),
            Text('• Your order number'),
            Text('• Proof of payment'),
            Text('• A clear explanation of the issue'),
            Text(
              'Requests that are incomplete or submitted after 7 days unfortunately cannot be reviewed.',
            ),
            SizedBox(height: 16),
            Text(
              'Need Help? We\'re here to assist you. If you have any questions about this policy or need help with an order, please reach out anytime: 📧 support@diamondstopup.com',
            ),
          ],
        ),
      ),
    );
  }
}

class CookiePolicyScreen extends StatelessWidget {
  const CookiePolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Cookie Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Understanding How We Use Cookies',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'This Cookie Policy explains how Diamond Top Up (“we,” “us,” or “our”) uses cookies and similar technologies when you visit our website at https://www.diamondstopup.com. It describes what these technologies are, why we use them, and the choices you have to manage them.',
            ),
            SizedBox(height: 8),
            Text(
              'In some cases, cookies may collect information that could be linked to you personally or combined with other data to identify you.',
            ),
            SizedBox(height: 16),
            Text(
              'What are cookies?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Cookies are small text files stored on your computer or mobile device when you browse a website. They are widely used to help websites function properly, work more efficiently, and provide useful information to website owners.',
            ),
            Text('First-party cookies are set directly by Diamond Top Up.'),
            Text(
              'Third-party cookies are placed by other companies to enable features like analytics, interactive content, or advertising. These third parties may be able to recognize your device across different websites and over time.',
            ),
            SizedBox(height: 16),
            Text(
              'Why We Use Cookies',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text('We use cookies for several reasons, such as:'),
            Text('• Operating and securing our Website'),
            Text('• Remembering your preferences and settings'),
            Text('• Analyzing how our Website is used so we can improve it'),
            Text(
              '• Providing you with a more relevant and personalized experience',
            ),
            Text(
              'Some cookies are essential for the site to work, while others help us enhance your experience.',
            ),
            SizedBox(height: 16),
            Text(
              'Your Cookie Choices',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'You have control over which cookies we use. Here\'s how you can manage your preferences:',
            ),
            Text(
              '• Cookie Consent Manager: When you visit our Website, you can set your cookie preferences using our Cookie Consent Manager, which lets you choose which categories of cookies you accept or reject.',
            ),
            Text(
              '• Browser Settings: Most web browsers allow you to manage cookies through their settings. Keep in mind that disabling certain cookies may impact your experience, such as remembering your login details or saving your preferences.',
            ),
            Text(
              '• Essential Cookies: Some cookies are strictly necessary for the Website to function. These cannot be turned off.',
            ),
            SizedBox(height: 16),
            Text(
              'Important Note',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'This is a sample Cookie Policy. You should replace it with a comprehensive version that includes:',
            ),
            Text('• A detailed list of specific cookies your website uses'),
            Text('• Their purpose and duration'),
            Text('• Instructions on how users can adjust their preferences'),
            Text(
              '• Information required to comply with applicable laws (such as the GDPR and ePrivacy Directive)',
            ),
            SizedBox(height: 16),
            Text(
              'Need Help?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'If you have questions about this Cookie Policy or how we use cookies, please contact us at: support@diamondstopup.com',
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Our Mission',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Diamonds Recharge, your premier destination for fast, secure, and reliable Diamond recharges. We understand the vibrant community of Diamonds Recharge users and aim to provide the easiest way for users to enhance their experience.',
            ),
            SizedBox(height: 8),
            Text(
              'Our platform is built with cutting-edge technology to ensure your transactions are smooth and your digital goods are delivered instantly. We are committed to providing top-notch customer service and competitive pricing for all your Diamonds needs.',
            ),
            SizedBox(height: 16),
            Text(
              'Authorized Reseller Notice',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'We are an authorized reseller of Bigo Live Diamonds. Please note that Bigo Live and this website are operated independently by separate companies and are not affiliated. Each company is solely responsible for its own services and operations.',
            ),
            SizedBox(height: 16),
            Text(
              'Why Choose Us?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              '• Instant Delivery: Get your Diamonds immediately after purchase.',
            ),
            Text(
              '• Secure Payments: Your payment information is processed securely.',
            ),
            Text(
              '• Competitive Prices: We offer great value on all Diamond packages.',
            ),
            Text(
              '• Dedicated Support: Our team is here to assist you with any queries.',
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for choosing Diamonds Recharge. We look forward to serving you!',
            ),
          ],
        ),
      ),
    );
  }
}

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  late List<bool> _expanded;

  final List<Map<String, String>> _faq = [
    {
      'question': 'How soon will I receive my BIGO Diamonds?',
      'answer':
          'In most cases, your Diamonds will be credited to your account within minutes after payment. During busy periods or for larger orders, it may take up to 30 minutes. If you don\'t receive them after that, please contact our support team.',
    },
    {
      'question': 'What payment options can I use?',
      'answer':
          'We support a variety of secure payment methods, including credit/debit cards and popular online payment platforms. Available payment options will appear at checkout.',
    },
    {
      'question': 'Is my payment information safe?',
      'answer':
          ' Absolutely. All transactions are handled through secure, encrypted payment processors, and we never store your payment details ourselves.',
    },
    {
      'question': 'Can I get a refund if I change my mind?',
      'answer':
          'Because Diamonds are digital products delivered immediately, purchases are final and cannot be refunded. For more details, please check our Refund Policy.',
    },
    {
      'question': 'What should I do if I don\'t get my Diamonds after paying?',
      'answer':
          'If your Diamonds don\'t arrive within 30 minutes, please get in touch with us so we can assist you promptly.',
    },
    {
      'question': 'Do I need to share my login details?',
      'answer':
          'No. We will never ask for your BIGO login information. You only need to provide your correct User ID to ensure your Diamonds are credited properly.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _expanded = List.generate(_faq.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18192A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Common Questions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common Questions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have other questions, feel free to contact our support team anytime — we are here to help!.',
            ),
            const SizedBox(height: 20),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _expanded[index] = !isExpanded;
                });
              },
              children: List.generate(_faq.length, (index) {
                return ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: _expanded[index],
                  headerBuilder: (context, isExpanded) => ListTile(
                    title: Text(
                      _faq[index]['question']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  body: ListTile(title: Text(_faq[index]['answer']!)),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
