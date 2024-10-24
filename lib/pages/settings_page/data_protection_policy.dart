import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DataProtectionPolicyPage extends StatelessWidget {
  const DataProtectionPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Protection Policy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context);
            },
          ),
        ],
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

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
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
              '   We are committed to protecting your personal data and ensuring its privacy, security, and confidentiality.',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '2. Data Collection',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '   We collect personal data that you provide to us directly, such as when you create an account, use our services, or contact us for support.',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '3. Data Use',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '   We use your personal data to provide and improve our services, communicate with you, and ensure the security of our platform.',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '4. Data Sharing',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '   We do not share your personal data with third parties except as necessary to provide our services, comply with legal obligations, or protect our rights.',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '5. Data Security',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '   We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, loss, or misuse.',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '6. Your Rights',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '   You have the right to access, correct, or delete your personal data, as well as the right to object to or restrict certain processing of your data.',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '7. Contact Us',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '   If you have any questions or concerns about our data protection practices, please contact us at support@example.com.',
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
