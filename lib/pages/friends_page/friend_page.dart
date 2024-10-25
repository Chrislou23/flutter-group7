import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<String> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

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

  Future<void> _saveFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String friendsData = json.encode(_friends);
    await prefs.setString('friendsList', friendsData);
  }

  // Function to share the invitation via social media
  Future<void> _shareOnSocialMedia() async {
    const String message = "I'm playing on FunLandia, come play with me!";
    Share.share(message);  // Uses share_plus to share the message
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                backgroundColor: const Color.fromARGB(255, 225, 178, 252),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _showAddFriendDialog(context);
              },
              icon: const Icon(Icons.person_add, color: Color.fromARGB(255, 0, 0, 0)),
              label: const Text(
                'Add New Friend',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          // Invite Friends Button (Only for Social Media Sharing)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                backgroundColor: const Color.fromARGB(255, 128, 212, 250),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _shareOnSocialMedia, // Share invitation message on social media
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text(
                'Invite Friends',
                style: TextStyle(color: Colors.white),
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
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String friendName = _friendController.text.trim();
                if (friendName.isNotEmpty) {
                  setState(() {
                    _friends.add(friendName);
                    _saveFriends();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$friendName added as a friend!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
