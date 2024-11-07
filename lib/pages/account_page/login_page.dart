import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_page/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Instance of FirebaseAuth for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Error message to display in case of login failure
  String _errorMessage = '';

  // Indicator to enable or disable the login button
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to update the login button state
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  // Update the state of the login button based on input fields
  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  // Function to handle user login
  Future<void> _login() async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      // Check if the user's email is verified
      if (user != null && !user.emailVerified) {
        // Send verification email if not verified
        await user.sendEmailVerification();
        setState(() {
          _errorMessage =
              'Please verify your email. A verification email has been sent to ${_emailController.text.trim()}';
        });
        return; // Do not proceed to login
      }

      // If email is verified, navigate to home page
      if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided.';
        } else {
          _errorMessage = e.message ?? 'An error occurred';
        }
      });
    } catch (e) {
      // Handle other errors
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  void dispose() {
    // Remove listeners and dispose controllers
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the app logo
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 10.0),
              child: Image.asset(
                'assets/appname.png', // Path to your logo image
                height: 350, // Adjust the height as needed
                width: 450, // Adjust the width as needed
              ),
            ),
            const SizedBox(height: 24.0), // Space after the logo

            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),

            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),

            // Login button
            ElevatedButton(
              onPressed: _isButtonEnabled ? _login : null,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),

            // Button to navigate to the registration page
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),

            // Display error message if any
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
}
