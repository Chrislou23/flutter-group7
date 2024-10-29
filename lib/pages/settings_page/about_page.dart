import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For email functionality

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Method to build a section title
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Method to build a paragraph
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  // Method to build a bullet point list
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the contact info
  Widget _buildContactInfo(BuildContext context, String email) {
    return GestureDetector(
      onTap: () async {
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: email,
        );
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch email client')),
          );
        }
      },
      child: Text(
        email,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Application Name
            Center(
              child: Text(
                'FunLandia',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('About This App'),
            _buildParagraph(
              'This app is designed to provide a fun and engaging gaming experience. Our goal is to create a platform where users can enjoy a variety of games and connect with friends.',
            ),
            _buildSectionTitle('Features'),
            _buildBulletPoint('Multiple games to choose from'),
            _buildBulletPoint('User-friendly interface'),
            _buildBulletPoint('Connect with friends and compete'),
            _buildBulletPoint('Regular updates and new content'),
            _buildSectionTitle('Contact Us'),
            _buildParagraph('If you have any questions or feedback, please contact us at:'),
            _buildContactInfo(context, 'support@funlandia.com'),
          ],
        ),
      ),
    );
  }
}
