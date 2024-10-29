import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart'; // For email functionality

class DataProtectionPolicyPage extends StatelessWidget {
  const DataProtectionPolicyPage({super.key});

  // Helper method to build section titles
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper method to build paragraphs
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  // Helper method to build email link
  Widget _buildEmailLink(BuildContext context, String email) {
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
          'Data Protection Policy',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: () {
              _downloadPDF(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Data Protection Policy'),
            _buildSectionTitle('1. Introduction'),
            _buildParagraph(
              'We are committed to protecting your personal data and ensuring its privacy, security, and confidentiality.',
            ),
            _buildSectionTitle('2. Data Collection'),
            _buildParagraph(
              'We collect personal data that you provide to us directly, such as when you create an account, use our services, or contact us for support.',
            ),
            _buildSectionTitle('3. Data Use'),
            _buildParagraph(
              'We use your personal data to provide and improve our services, communicate with you, and ensure the security of our platform.',
            ),
            _buildSectionTitle('4. Data Sharing'),
            _buildParagraph(
              'We do not share your personal data with third parties except as necessary to provide our services, comply with legal obligations, or protect our rights.',
            ),
            _buildSectionTitle('5. Data Security'),
            _buildParagraph(
              'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, loss, or misuse.',
            ),
            _buildSectionTitle('6. Your Rights'),
            _buildParagraph(
              'You have the right to access, correct, or delete your personal data, as well as the right to object to or restrict certain processing of your data.',
            ),
            _buildSectionTitle('7. Contact Us'),
            _buildParagraph('If you have any questions or concerns about our data protection practices, please contact us at:'),
            _buildEmailLink(context, 'support@example.com'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Data Protection Policy',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '1. Introduction',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'We are committed to protecting your personal data and ensuring its privacy, security, and confidentiality.',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '2. Data Collection',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'We collect personal data that you provide to us directly, such as when you create an account, use our services, or contact us for support.',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '3. Data Use',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'We use your personal data to provide and improve our services, communicate with you, and ensure the security of our platform.',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '4. Data Sharing',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'We do not share your personal data with third parties except as necessary to provide our services, comply with legal obligations, or protect our rights.',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '5. Data Security',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, loss, or misuse.',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '6. Your Rights',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'You have the right to access, correct, or delete your personal data, as well as the right to object to or restrict certain processing of your data.',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '7. Contact Us',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'If you have any questions or concerns about our data protection practices, please contact us at support@example.com.',
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
