import 'package:ems/Pages/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../database/LoginFB.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        // Navigate to Home Page or another page, passing user ID
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(userId: user.uid),
        ));
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xFFB3A4F6),
          automaticallyImplyLeading: false,
          title: Center(child: Text('Login'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              // Profile Icon
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Login Form Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Email Field
                    Row(
                      children: const [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF7E96D3), // Color for TextField background
                        borderRadius:
                            BorderRadius.circular(20), // Full rounded corners
                      ),
                      child: TextField(
                        controller: _emailController, // Set controller
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    Row(
                      children: const [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF7E96D3), // Color for TextField background
                        borderRadius:
                            BorderRadius.circular(20), // Full rounded corners
                      ),
                      child: TextField(
                        controller: _passwordController, // Set controller
                        obscureText: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF7E96D3), // Color for Button background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                      ),
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 10),
                    // Sign Up Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF7E96D3), // Color for Button background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        // Navigate to Sign Up Page (assuming you have a SignUpPage)
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
