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
            Navigator.pop(context); // Navigate back to the previous page
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
      body: Column(
        children: [
          // The list of friends
          Expanded(
            child: ListView(
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
          ),
          // The button to add a friend at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                backgroundColor: const Color.fromARGB(255, 225, 178, 252),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(
                    double.infinity, 50), // Makes the button full-width
              ),
              onPressed: () {
                _showAddFriendDialog(context);
              },
              icon: const Icon(Icons.person_add,
                  color: Color.fromARGB(255, 0, 0, 0)),
              label: const Text(
                'Add New Friend',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final TextEditingController _friendController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            controller: _friendController,
            decoration: const InputDecoration(
              hintText: 'Enter friend\'s username',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle adding the friend logic here
                String friendName = _friendController.text.trim();
                if (friendName.isNotEmpty) {
                  // Do something with the friend name (e.g., send a request or add to the list)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$friendName added as a friend!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
