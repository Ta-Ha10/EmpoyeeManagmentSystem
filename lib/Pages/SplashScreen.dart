import 'dart:async';

import 'package:flutter/material.dart';

import 'LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Plus App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Start with the Splash Screen
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to the Login Screen after 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Text(
          "Work Plus App",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB3A4F6),
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
