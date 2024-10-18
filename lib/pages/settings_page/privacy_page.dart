import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Introduction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We are committed to protecting your privacy and ensuring the security of your personal information.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Information Collection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We collect information that you provide to us directly, such as when you create an account, use our services, or contact us for support.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Use of Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We use your information to provide and improve our services, communicate with you, and ensure the security of our platform.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Sharing of Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We do not share your personal information with third parties except as necessary to provide our services, comply with legal obligations, or protect our rights.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Data Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, loss, or misuse.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Your Rights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   You have the right to access, correct, or delete your personal information, as well as the right to object to or restrict certain processing of your data.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   If you have any questions or concerns about our privacy practices, please contact us at support@example.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
