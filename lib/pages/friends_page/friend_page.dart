import 'package:flutter/material.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
        title: const Text('Friends', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Action for settings icon
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.account_circle, size: 40),
            title: Text('Pierre3960'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle, size: 40),
            title: Text('Luke'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle, size: 40),
            title: Text('Robert'),
          ),
        ],
      ),
    );
  }
}
