import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String errorMessage = '';

  Future<void> registerUser() async {
    setState(() {
      errorMessage = ''; // Clear any previous error messages at the start
    });

    // Check if all fields are filled
    if (_usernameController.text.trim().isEmpty ||
        _nicknameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields!";
      });
      return;
    }

    try {
      // Ensure passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          errorMessage = "Passwords do not match!";
        });
        return;
      }

      print("Attempting to create user...");

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

      print("User info stored in Firestore");

      // Show success message using SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Your account has been created successfully')),
        );

        // Navigate to the login page after the SnackBar is shown
        await Future.delayed(
            const Duration(seconds: 2)); // Give some delay to show the SnackBar
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}, ${e.message}");
      setState(() {
        errorMessage = e.message ?? "An error occurred during registration!";
      });
    } catch (e, stacktrace) {
      print("Unexpected error: $e");
      print("Stacktrace: $stacktrace");
      setState(() {
        errorMessage = "An unexpected error occurred!";
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free resources when widget is removed
    _usernameController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Register', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username (Email)',
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nickname',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
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
      ),
    );
  }
}
