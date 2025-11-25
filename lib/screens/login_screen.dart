import 'package:flutter/material.dart';
import 'package:mob_project/screens/main_screen.dart';
import 'package:mob_project/screens/signup_screen.dart';
import 'package:mob_project/screens/home_screen.dart';

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
                _buildTextField(
                  controller: _emailController,
                  hintText: "Enter your Username or Email address",
                  icon: null,
                ),
                const SizedBox(height: 20),

                _buildLabel("PASSWORD"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: "Enter your Password",
                  obscureText: !_isPasswordVisible,
                  icon: IconButton(
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
                SizedBox(
                  width: 160, // Fixed width pill shape
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to home and remove login from back stack
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const mainScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
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
                _buildSocialButton(
                  text: "Continue with Google",
                  // Using a network image for Google Icon
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                    height: 24,
                  ),
                ),
                const SizedBox(height: 15),
                _buildSocialButton(
                  text: "Continue with Facebook",
                  // Using a network image for Facebook Icon
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/150px-2021_Facebook_icon.svg.png',
                    height: 24,
                  ),
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

  // Helper widget for TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: _inputFillColor,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.blueGrey[300],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: icon,
        ),
      ),
    );
  }

  // Helper widget for Social Buttons
  Widget _buildSocialButton({required String text, required Widget icon}) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF90E0FF), // Light blue social btn
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            Padding(padding: const EdgeInsets.only(left: 10), child: icon),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            // Invisible spacer to balance the icon on the left
            const SizedBox(width: 34),
          ],
        ),
      ),
    );
  }
}
