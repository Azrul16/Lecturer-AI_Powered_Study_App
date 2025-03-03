import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lecturer/login_credentials/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Slide from Bottom Animation
    _animation = Tween<Offset>(
      begin: Offset(0.0, 1.0), // Start from bottom
      end: Offset(0.0, 0.0), // Move to center
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // Start animation

    // Navigate to Login Page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _animation,
              child: Image.asset("assets/logo.png", width: 150), // Logo Image
            ),
            SizedBox(height: 10),
            SlideTransition(
              position: _animation,
              child: Text(
                "Lecturer",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Change color as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
