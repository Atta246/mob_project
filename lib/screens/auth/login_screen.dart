import 'package:flutter/material.dart';
import 'package:mob_project/screens/home/main_screen.dart';
import 'package:mob_project/screens/auth/signup_screen.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/constants/constants.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define colors from the design
  final Color _bgTopColor = const Color(0xFF8AE4FF); // Light blue top
  final Color _bgBottomColor = const Color(0xFFEBEBEB); // Greyish bottom
  final Color _inputFillColor = const Color(0xFFCFEFF8); // Pale blue input bg
  final Color _buttonColor = const Color(0xFF81D4FA); // Login button color
  final Color _textColor = const Color(0xFF37474F); // Dark grey text

  @override
  Widget build(BuildContext context) {
    // Screen size for responsive layout
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTopColor, _bgBottomColor],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ...existing code...
                // Option A — use screen width fraction
                Image.asset(
                  'assets/images/logo.png',
                  width: size.width * 0.6, // 60% of screen width

                  fit: BoxFit.contain,
                ),
                // ...existing code...
                const SizedBox(),
                Text(
                  "Login to your account to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 40),

                // --- Input Fields ---
                _buildLabel("USERNAME OR EMAIL"),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Enter your Username or Email address",
                  fillColor: _inputFillColor,
                ),
                const SizedBox(height: 20),

                _buildLabel("PASSWORD"),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Enter your Password",
                  obscureText: !_isPasswordVisible,
                  fillColor: _inputFillColor,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),

                // --- Forgot Password ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // --- Login Button ---
                CustomButton(
                  text: "LOGIN",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const mainScreen(),
                      ),
                    );
                  },
                  backgroundColor: _buttonColor,
                  height: 50,
                ),
                const SizedBox(height: 20),

                // --- Sign Up Link ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ? ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const signupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- OR Divider ---
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Colors.black54, thickness: 1.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Colors.black54, thickness: 1.2),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Social Buttons ---
                SocialLoginButton(
                  text: "Continue with Google",
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                    height: 24,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 15),
                SocialLoginButton(
                  text: "Continue with Facebook",
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/150px-2021_Facebook_icon.svg.png',
                    height: 24,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for Labels
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
