import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<Map<String, dynamic>> _friends = [];
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    if (_currentUser == null) return;
    try {
      QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('friends')
          .get();

      List<Map<String, dynamic>> loadedFriends = [];

      for (var doc in friendsSnapshot.docs) {
        // Get friend's user ID
        String friendUserId = doc.id;

        // Get friend's data
        DocumentSnapshot friendDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUserId)
            .get();

        if (friendDoc.exists) {
          Map<String, dynamic>? data = friendDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            loadedFriends.add({
              'userId': friendUserId,
              'username': data['username'] ?? 'Unknown',
              'photoURL': data['photoURL'] ?? '',
              'scoreTotal': data['scoreTotal'] ?? 0, // Added scoreTotal
            });
          }
        }
      }

      setState(() {
        _friends = loadedFriends;
      });
    } catch (e) {
      print('Error loading friends: $e');
    }
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
        title: const Text('Friends'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadFriends,
              child: _friends.isEmpty
                  ? const Center(child: Text('No friends yet'))
                  : ListView.builder(
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        String username = _friends[index]['username'] ?? 'Unknown';
                        String photoURL = _friends[index]['photoURL'] ?? '';
                        int scoreTotal = _friends[index]['scoreTotal'] ?? 0; // Get scoreTotal

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: photoURL.isNotEmpty
                                ? NetworkImage(photoURL)
                                : null,
                            child: photoURL.isEmpty
                                ? const Icon(Icons.account_circle, size: 40)
                                : null,
                          ),
                          title: Text(username),
                          subtitle: Text('Total Score: $scoreTotal'), // Display scoreTotal
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _removeFriend(_friends[index]['userId'], username);
                            },
                          ),
                          onTap: () {
                            // Optionally, navigate to friend's profile page
                          },
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _showAddFriendDialog(context);
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Add New Friend'),
            ),
          ),
          // Invite Friends Button (Only for Social Media Sharing)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _shareOnSocialMedia, // Share invitation message on social media
              icon: const Icon(Icons.share),
              label: const Text('Invite Friends'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final TextEditingController _friendController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Friend',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _friendController,
                  decoration: const InputDecoration(
                    hintText: 'Enter friend\'s username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        String friendName = _friendController.text.trim();
                        if (friendName.isNotEmpty) {
                          await _addFriend(friendName);
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addFriend(String friendName) async {
    if (_currentUser == null) return;

    try {
      // Query Firestore to find the user with the given username
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: friendName)
          .get();

      if (userSnapshot.docs.isEmpty) {
        _showErrorSnackBar('User "$friendName" not found.');
        return;
      }

      // Assuming usernames are unique, get the first document
      DocumentSnapshot friendDoc = userSnapshot.docs.first;
      String friendUserId = friendDoc.id;

      // Check if already friends
      DocumentSnapshot existingFriend = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('friends')
          .doc(friendUserId)
          .get();

      if (existingFriend.exists) {
        _showErrorSnackBar('You are already friends with $friendName.');
        return;
      }

      // Add the friend to the current user's 'friends' subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('friends')
          .doc(friendUserId)
          .set({'addedAt': FieldValue.serverTimestamp()});

      // Optionally, add the current user to the friend's 'friends' subcollection for mutual friendship
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUserId)
          .collection('friends')
          .doc(_currentUser!.uid)
          .set({'addedAt': FieldValue.serverTimestamp()});

      // Reload the friends list
      await _loadFriends();

      _showSuccessSnackBar('$friendName added as a friend!');
    } catch (e) {
      print('Error adding friend: $e');
      _showErrorSnackBar('Failed to add friend: $e');
    }
  }

  void _removeFriend(String friendUserId, String friendName) async {
    if (_currentUser == null) return;

    try {
      // Remove the friend from the current user's 'friends' subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('friends')
          .doc(friendUserId)
          .delete();

      // Optionally, remove the current user from the friend's 'friends' subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUserId)
          .collection('friends')
          .doc(_currentUser!.uid)
          .delete();

      // Reload the friends list
      await _loadFriends();

      _showSuccessSnackBar('$friendName removed from friends.');
    } catch (e) {
      print('Error removing friend: $e');
      _showErrorSnackBar('Failed to remove friend: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
