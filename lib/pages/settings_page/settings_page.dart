import 'package:flutter/material.dart';

// SettingsPage displays a list of setting options
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Method to build each setting item with an icon, title, and navigation action
  Widget _buildSettingItem({
    required IconData icon, // Icon displayed for the setting
    required String title, // Title of the setting
    required VoidCallback onTap, // Action when the setting is tapped
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2, // Card shadow for elevation effect
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(icon, size: 28.0, color: Colors.blueAccent), // Leading icon
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0), // Trailing arrow icon
        onTap: onTap, // Navigate when tapped
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings', // AppBar title
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white, // White background for AppBar
        centerTitle: true, // Center title alignment
        elevation: 1, // Slight shadow below AppBar
        iconTheme: const IconThemeData(color: Colors.black), // Back icon color
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: <Widget>[
          // Setting item for Data Protection Policy, navigates to specified route
          _buildSettingItem(
            icon: Icons.security,
            title: 'Data Protection Policy',
            onTap: () {
              Navigator.pushNamed(context, '/data_protection_policy');
            },
          ),
          // Setting item for About, navigates to specified route
          _buildSettingItem(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          // Additional setting items can be added here as needed
        ],
      ),
    );
  }
}
