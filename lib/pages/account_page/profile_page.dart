import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_games/pages/home_page/home_page.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({super.key, required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _photoURL;
  String _username = '';
  int _level = 1;
  int _pointsForNextLevel = 1000;
  int _currentPoints = 0;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user?.email ?? '';
    _photoURL = widget.user?.photoURL;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user?.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'Unknown';
          _level = userDoc['level'] ?? 1;
          _currentPoints = userDoc['currentPoints'] ?? 0;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch user data: $e');
    }
  }

  Future<void> _updateUsername() async {
    String newUsername = _usernameController.text.trim();

    if (newUsername.isEmpty) {
      _showErrorSnackBar('Username cannot be empty.');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user?.uid)
          .update({'username': newUsername});

      setState(() {
        _username = newUsername;
      });

      Navigator.of(context).pop(); // Close the dialog

      _showSuccessSnackBar('Username updated successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to update username: $e');
    }
  }

  Future<void> _updateProfilePicture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      File imageFile = File(image.path);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${widget.user?.uid}.jpg');
      await storageRef.putFile(imageFile);

      String photoURL = await storageRef.getDownloadURL();

      await widget.user?.updatePhotoURL(photoURL);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user?.uid)
          .update({'photoURL': photoURL});

      setState(() {
        _photoURL = photoURL;
      });

      _showSuccessSnackBar('Profile picture updated successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to update profile picture: $e');
    }
  }

  Future<void> _updateEmail() async {
    try {
      await widget.user?.verifyBeforeUpdateEmail(_emailController.text);
      _showSuccessSnackBar(
          'Verification email sent. Please verify your new email before updating.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showReauthenticationDialog();
      } else {
        _showErrorSnackBar('Failed to update email: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to update email: $e');
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: widget.user!.email!);
      _showSuccessSnackBar('Password reset email sent');
    } catch (e) {
      _showErrorSnackBar('Failed to send password reset email: $e');
    }
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user?.uid)
          .delete();

      await widget.user?.delete();

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showReauthenticationDialog();
      } else {
        _showErrorSnackBar('Failed to delete account: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to delete account: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorSnackBar('Failed to sign out: $e');
    }
  }

  void _showReauthenticationDialog() {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Re-authentication Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your password to continue.'),
              const SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _reauthenticate(_passwordController.text);
              },
              child: const Text('Re-authenticate'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reauthenticate(String password) async {
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: widget.user!.email!,
        password: password,
      );
      await widget.user?.reauthenticateWithCredential(credential);
      _showSuccessSnackBar(
          'Re-authentication successful. Please try again.');
    } catch (e) {
      _showErrorSnackBar('Re-authentication failed: $e');
    }
  }

  void _showEditUsernameDialog() {
    _usernameController.text = _username;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter new username',
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
            ElevatedButton(
              onPressed: () async {
                await _updateUsername();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void addPoints(int points) {
    setState(() {
      _currentPoints += points;
      if (_currentPoints >= _pointsForNextLevel) {
        _level++;
        _currentPoints -= _pointsForNextLevel;
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user?.uid)
        .update({
      'level': _level,
      'currentPoints': _currentPoints,
    });
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _currentPoints / _pointsForNextLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              _photoURL != null && _photoURL!.isNotEmpty
                                  ? NetworkImage(_photoURL!)
                                  : null,
                          child: _photoURL == null || _photoURL!.isEmpty
                              ? const Icon(Icons.account_circle, size: 60)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: _updateProfilePicture,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _username,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: _showEditUsernameDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Level $_level',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${_currentPoints} / $_pointsForNextLevel points',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Account Actions
            ListTile(
              leading: const Icon(Icons.email),
              title: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.save),
                onPressed: _updateEmail,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: _sendPasswordResetEmail,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: _signOut,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete Account'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: _showDeleteConfirmationDialog,
            ),
          ],
        ),
      ),
    );
  }
}
