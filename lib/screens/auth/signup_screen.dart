import 'package:flutter/material.dart';
import 'package:mob_project/screens/home/main_screen.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/constants/constants.dart';

// ignore: camel_case_types
class signupScreen extends StatefulWidget {
  const signupScreen({super.key});

  @override
  State<signupScreen> createState() => _signupScreenState();
}

class _signupScreenState extends State<signupScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define colors from the design (reused)
  final Color _bgTopColor = const Color(0xFF8AE4FF);
  final Color _bgBottomColor = const Color(0xFFEBEBEB);
  final Color _inputFillColor = const Color(0xFFCFEFF8);
  final Color _buttonColor = const Color(0xFF81D4FA);

  @override
  Widget build(BuildContext context) {
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
                // Back button to go back to Login (Optional, but good UX)
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // --- Logo Section ---
                Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                const SizedBox(height: 20),
                Text(
                  "Create New Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 40),

                // --- Input Fields ---

                // 1. Username
                _buildLabel("USERNAME"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _usernameController,
                  hintText:
                      "", // Image shows empty hint, but you can add "Enter Username"
                ),
                const SizedBox(height: 20),

                // 2. Email
                _buildLabel("EMAIL"),
                const SizedBox(height: 8),
                _buildTextField(controller: _emailController, hintText: ""),
                const SizedBox(height: 20),

                // 3. Password
                _buildLabel("PASSWORD"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: "",
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

                // --- Sign Up Button ---
                CustomButton(
                  text: "SIGN UP",
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

                const SizedBox(height: 30),

                // --- OR Divider ---
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.black54, thickness: 1.2),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.black54, thickness: 1.2),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Social Buttons ---
                _buildSocialButton(
                  text: "Sign in with Google",
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                    height: 24,
                  ),
                ),
                const SizedBox(height: 15),
                _buildSocialButton(
                  text: "Sign in with Facebook",
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

  // --- Helpers for Sign Up Screen ---
  // (Duplicated for simplicity in this single-file example)

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
          backgroundColor: const Color(0xFF90E0FF),
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
            const SizedBox(width: 34),
          ],
        ),
      ),
    );
  }
}
