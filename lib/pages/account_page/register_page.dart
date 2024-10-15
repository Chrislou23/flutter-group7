import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // Import this to check initialization

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String errorMessage = '';

  Future<void> registerUser() async {
    try {
      // Ensure Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          errorMessage = "Passwords do not match!";
        });
        return;
      }

      // Register with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print("User created successfully: ${userCredential.user?.uid}");

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': _usernameController.text.trim(),
        'nickname': _nicknameController.text.trim(),
      });

      // Navigate to login or home screen after registration
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An error occurred during registration!";
      });
      print("FirebaseAuthException: ${e.code} - ${e.message}");
    } catch (e) {
      setState(() {
        errorMessage = "An unexpected error occurred!";
      });
      print("Unexpected error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Register', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController, // Attach controller
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username (Email)',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nicknameController, // Attach controller
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nickname',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController, // Attach controller
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController, // Attach controller
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: 16.0),
            if (errorMessage.isNotEmpty) ...[
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16.0),
            ],
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
