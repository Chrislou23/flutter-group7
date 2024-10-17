import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _errorMessage = '';
  String? _photoURL;
  String _username = ''; // Initialize the username

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email ?? '';
    _photoURL = widget.user.photoURL;
    _fetchUsername(); // Fetch user data when the profile page is initialized
  }

  Future<void> _fetchUsername() async {
    try {
      // Fetch the username from Firestore or other data source
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'Unknown'; // Set the username
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch username: $e';
      });
    }
  }

  Future<void> _updateUsername(BuildContext dialogContext) async {
    String newUsername = _usernameController.text.trim();

    if (newUsername.isEmpty) {
      setState(() {
        _errorMessage = 'Username cannot be empty.';
      });
      return;
    }

    try {
      // Update the username in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'username': newUsername});

      // Update the local state to reflect the new username
      setState(() {
        _username = newUsername;
        _errorMessage = ''; // Clear error message if successful
      });

      // Close the dialog after updating
      if (mounted) {
        Navigator.of(dialogContext).pop();
      }

      // Show a success message using the context from the Scaffold
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Username updated successfully!'),
          backgroundColor: Colors.green, // Set the background color to green
          behavior: SnackBarBehavior.floating, // Optional: make it floating
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update username: $e';
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    try {
      // Pick an image from the gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      File imageFile = File(image.path);

      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${widget.user.uid}.jpg');
      await storageRef.putFile(imageFile);

      // Get the download URL of the uploaded image
      String photoURL = await storageRef.getDownloadURL();

      // Update the user's profile
      await widget.user.updatePhotoURL(photoURL);

      // Update the Firestore user document if necessary
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'photoURL': photoURL});

      setState(() {
        _photoURL = photoURL;
        _errorMessage = 'Profile picture updated successfully!';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update profile picture: $e';
      });
    }
  }

  Future<void> _updateEmail() async {
    try {
      await widget.user.verifyBeforeUpdateEmail(_emailController.text);
      setState(() {
        _errorMessage =
            'Verification email sent. Please verify your new email before updating.';
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showReauthenticationDialog();
      } else {
        setState(() {
          _errorMessage = 'Failed to update email: ${e.message}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update email: $e';
      });
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: widget.user.email!);
      setState(() {
        _errorMessage = 'Password reset email sent';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send password reset email: $e';
      });
    }
  }

  Future<void> _deleteAccount() async {
    try {
      // Delete user data from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .delete();

      // Delete user account from Firebase Authentication
      await widget.user.delete();

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showReauthenticationDialog();
      } else {
        setState(() {
          _errorMessage = 'Failed to delete account: ${e.message}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to delete account: $e';
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign out: $e';
      });
    }
  }

  void _showReauthenticationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _passwordController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Re-authentication Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your password to continue.'),
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
            TextButton(
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
        email: widget.user.email!,
        password: password,
      );
      await widget.user.reauthenticateWithCredential(credential);
      setState(() {
        _errorMessage = 'Re-authentication successful. Please try again.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Re-authentication failed: $e';
      });
    }
  }

  void _showEditUsernameDialog() {
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
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call the update method and wait for it to complete
                await _updateUsername(dialogContext);

                if (_errorMessage.isEmpty) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(dialogContext).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            _photoURL != null && _photoURL!.isNotEmpty
                                ? NetworkImage(_photoURL!)
                                : null,
                        child: _photoURL == null || _photoURL!.isEmpty
                            ? const Icon(Icons.account_circle, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 7,
                        right: 0,
                        left: 87,
                        child: GestureDetector(
                          onTap: _updateProfilePicture,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 44, 75, 170),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 20.0),
                          Text(
                            _username,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: _showEditUsernameDialog,
                            child: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 44, 75, 170),
                              size: 17,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('Update Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: const Text('Change Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showDeleteConfirmationDialog,
              child: const Text('Delete Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Disconnect'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
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
            TextButton(
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
}
