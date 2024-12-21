import 'package:ems/Pages/LoginPage.dart';
import 'package:ems/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../database/signupFB.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ssnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? _userData;
  int? _userId;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ssnController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _previewUser() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String ssn = _ssnController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      int userId = await _firebaseService.getNextUserId();
      setState(() {
        _userData = {
          'id': userId,
          'name': name,
          'phone': phone,
          'ssn': ssn,
          'email': email,
        };
        _userId = userId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _signup() async {
    if (_userData == null || _userId == null) {
      return;
    }
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user = await _auth.signupWithEmailandPassword(email, password);

      if (user != null) {
        await _firebaseService.addUserDocumentWithAutoIncrementId(
            user.uid, _userData!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User successfully created')),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage();
          },
        ));
      } else {
        throw Exception('User creation failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign UP')),
        backgroundColor: const Color(0xFFB3A4F6),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: const Color(0xFF7E96D3),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        filled: true,
                        fillColor: const Color(0xFF7E96D3),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ssnController,
                      decoration: InputDecoration(
                        labelText: 'SSN',
                        filled: true,
                        fillColor: const Color(0xFF7E96D3),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: const Color(0xFF7E96D3),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: const Color(0xFF7E96D3),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _previewUser,
                      child: const Text(
                        'Preview',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF654E91),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_userData != null)
                      Column(
                        children: [
                          Text('ID: ${_userData!['id']}'),
                          Text('Name: ${_userData!['name']}'),
                          Text('Phone: ${_userData!['phone']}'),
                          Text('SSN: ${_userData!['ssn']}'),
                          Text('Email: ${_userData!['email']}'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _signup,
                            child: const Text(
                              'Confirm & Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF654E91),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
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
