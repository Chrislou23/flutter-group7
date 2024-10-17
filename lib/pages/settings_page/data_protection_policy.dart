import 'package:flutter/material.dart';

class DataProtectionPolicyPage extends StatelessWidget {
  const DataProtectionPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Protection Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Data Protection Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Introduction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We are committed to protecting your personal data and ensuring its privacy, security, and confidentiality.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Data Collection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We collect personal data that you provide to us directly, such as when you create an account, use our services, or contact us for support.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Data Use',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We use your personal data to provide and improve our services, communicate with you, and ensure the security of our platform.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Data Sharing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We do not share your personal data with third parties except as necessary to provide our services, comply with legal obligations, or protect our rights.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Data Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, loss, or misuse.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Your Rights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   You have the right to access, correct, or delete your personal data, as well as the right to object to or restrict certain processing of your data.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   If you have any questions or concerns about our data protection practices, please contact us at support@example.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
