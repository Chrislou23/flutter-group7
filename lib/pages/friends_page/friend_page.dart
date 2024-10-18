import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  // List to hold the names of friends
  List<String> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends(); // Load friends when the page is initialized
  }

  // Method to load friends from SharedPreferences
  Future<void> _loadFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? friendsData = prefs.getString('friendsList');
    if (friendsData != null) {
      List<String> loadedFriends = List<String>.from(json.decode(friendsData));
      setState(() {
        _friends = loadedFriends;
      });
    }
  }

  // Method to save friends to SharedPreferences
  Future<void> _saveFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String friendsData = json.encode(_friends);
    await prefs.setString('friendsList', friendsData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Friends', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // The list of friends
          Expanded(
            child: ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.account_circle, size: 40),
                  title: Text(_friends[index]),
                );
              },
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
                String friendName = _friendController.text.trim();
                if (friendName.isNotEmpty) {
                  setState(() {
                    _friends.add(friendName);
                    _saveFriends(); // Save the updated list
                  });
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
