// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lecturer/login_credentials/create_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00B4DB),
                  Color(0xFF0083B0),
                ], // Sky Blue to Blue
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Login Form
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.1), // Glassmorphic effect
                  borderRadius: BorderRadius.circular(20),
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Welcome Text
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Email Input
                    _buildTextField("Enter your Gmail", Icons.email, false),

                    const SizedBox(height: 15),

                    // Password Input
                    _buildTextField("Enter your Password", Icons.lock, true),

                    const SizedBox(height: 20),

                    // Login Button
                    _buildLoginButton(),

                    const SizedBox(height: 15),

                    // Create Account Button
                    _buildCreateAccountButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Text Fields with Glassmorphic UI
  Widget _buildTextField(String hint, IconData icon, bool obscure) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Neon-Glowing Login Button
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Create Account Button
  Widget _buildCreateAccountButton() {
    return Column(
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Navigate to Create Account Page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateAccountPage(),
              ),
            );
          },
          child: const Text(
            "Create an Account",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
