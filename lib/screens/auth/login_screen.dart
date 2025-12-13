import 'package:flutter/material.dart';
import 'package:mob_project/screens/home/main_screen.dart';
import 'package:mob_project/screens/auth/signup_screen.dart';
import 'package:mob_project/screens/auth/complete_profile_screen.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mob_project/widgets/common/success_dialog.dart';
import 'package:mob_project/services/auth_service.dart';
import 'package:mob_project/services/google_sign_in_service.dart';
import 'package:mob_project/services/profile_service.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;

  final AuthService _authService = AuthService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  final ProfileService _profileService = ProfileService();

  Future<void> _loginWithEmailPassword() async {
    // Validate all fields first
    setState(() {
      _emailError = Validators.validateEmail(_emailController.text);
      _passwordError = Validators.validatePassword(_passwordController.text);
    });

    // Check if validation passed
    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with email and password using AuthService
      await _authService.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if profile is complete
        final isComplete = await _profileService.isProfileComplete();
        if (!isComplete) {
          // Profile is incomplete, navigate to complete profile screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CompleteProfileScreen(),
            ),
          );
          return;
        }

        // Show success dialog
        await SuccessDialog.show(
          context,
          title: 'Welcome Back!',
          message: 'You have successfully logged in.',
          onOkPressed: () {
            // Navigate to main screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const mainScreen()),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ModernSnackBar.show(
          context,
          AuthService.getErrorMessage(e),
          type: SnackBarType.error,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ModernSnackBar.show(
          context,
          'Error: ${e.toString()}',
          type: SnackBarType.error,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential? credential = await _googleSignInService
          .signInWithGoogle();

      if (credential != null && mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if profile is complete
        final isComplete = await _profileService.isProfileComplete();
        if (!isComplete) {
          // Profile is incomplete, navigate to complete profile screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CompleteProfileScreen(),
            ),
          );
          return;
        }

        showDialog(
          context: context,
          builder: (context) => const SuccessDialog(
            title: 'Success',
            message: 'Successfully signed in',
          ),
        ).then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const mainScreen()),
          );
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ModernSnackBar.show(
          context,
          'Google Sign-In Error: ${e.toString()}',
          type: SnackBarType.error,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Define colors from the design
  final Color _bgTopColor = const Color(0xFF8AE4FF); // Light blue top
  final Color _bgBottomColor = const Color(0xFFEBEBEB); // Greyish bottom
  final Color _inputFillColor = const Color(0xFFCFEFF8); // Pale blue input bg
  final Color _buttonColor = const Color(0xFF81D4FA); // Login button color

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
            child: Form(
              key: _formKey,
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
                  _buildLabel("EMAIL"),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Enter your Email address",
                        fillColor: _inputFillColor,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _emailError = Validators.validateEmail(value);
                          });
                        },
                      ),
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 4),
                          child: Text(
                            _emailError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("PASSWORD"),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "Enter your Password",
                        obscureText: !_isPasswordVisible,
                        fillColor: _inputFillColor,
                        onChanged: (value) {
                          setState(() {
                            _passwordError = Validators.validatePassword(value);
                          });
                        },
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
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 4),
                          child: Text(
                            _passwordError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
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
                    onPressed: _isLoading ? () {} : _loginWithEmailPassword,
                    backgroundColor: _buttonColor,
                    height: 50,
                    isLoading: _isLoading,
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
                    onPressed: _signInWithGoogle,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
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
