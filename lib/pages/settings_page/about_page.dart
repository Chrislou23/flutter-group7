import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'About This App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'This app is designed to provide a fun and engaging gaming experience. Our goal is to create a platform where users can enjoy a variety of games and connect with friends.',
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Multiple games to choose from',
              ),
              Text(
                '   - User-friendly interface',
              ),
              Text(
                '   - Connect with friends and compete',
              ),
              Text(
                '   - Regular updates and new content',
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   If you have any questions or feedback, please contact us at support@example.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
