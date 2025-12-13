import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mob_project/screens/auth/login_screen.dart';
import 'package:mob_project/screens/auth/signup_screen.dart';
import 'package:mob_project/services/auth_service.dart';
import 'package:mob_project/services/profile_service.dart';
import 'package:mob_project/screens/test_data_screen.dart';
import '../../widgets/widgets.dart';
import '../../widgets/common/success_dialog.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import '../home/main_screen.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class SettingsDetailScreen extends StatelessWidget {
  SettingsDetailScreen({super.key});

  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMenuItem(
              Icons.person_outline,
              'Edit Profile',
              Colors.blue,
              () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              Icons.lock_outline,
              'Change Password',
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              Icons.science_outlined,
              'Generate Test Data',
              Colors.green,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestDataScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              Icons.delete_outline,
              'Delete Account',
              Colors.red,
              () => _showDeleteAccountDialog(context),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            Navigator.pop(context, (route) => route.isFirst);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => mainScreen(initialIndex: index),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from all providers (Google, Email, etc.)
      await _authService.signOut();

      if (context.mounted) {
        await SuccessDialog.show(
          context,
          title: 'Goodbye!',
          message: 'You have been successfully logged out.',
          onOkPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const loginScreen()),
              (route) => false,
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ModernSnackBar.show(
          context,
          'Error logging out: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure you want to delete your account?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'This action will permanently:',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    _buildDeletePoint('Delete all your bookings'),
                    _buildDeletePoint('Remove all your tickets'),
                    _buildDeletePoint('Delete all your reviews'),
                    _buildDeletePoint('Return booked seats to trips'),
                    _buildDeletePoint('Remove all personal data'),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[700],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This action cannot be undone!',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Enter your password to confirm:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final password = passwordController.text.trim();

                    if (password.isEmpty) {
                      ModernSnackBar.show(
                        context,
                        'Please enter your password to confirm',
                        type: SnackBarType.warning,
                      );
                      return;
                    }

                    Navigator.of(context).pop();
                    _deleteAccount(context, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDeletePoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context, String password) async {
    BuildContext? loadingContext;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        loadingContext = dialogContext;
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Verifying and deleting...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Re-authenticate user before deletion
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        throw Exception('No user logged in');
      }

      // Create credential and re-authenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Now delete the account
      await _profileService.deleteAccount();

      // Close loading dialog
      if (loadingContext != null) {
        try {
          Navigator.of(loadingContext!).pop();
        } catch (_) {}
      }

      if (context.mounted) {
        // Navigate directly to login and clear all routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const loginScreen()),
          (route) => false,
        );

        // Show success message after navigation
        Future.delayed(Duration(milliseconds: 300), () {
          if (context.mounted) {
            ModernSnackBar.show(
              context,
              'Account deleted successfully',
              type: SnackBarType.success,
              duration: Duration(seconds: 3),
            );
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      // Close loading dialog using its own context
      if (loadingContext != null) {
        try {
          Navigator.of(loadingContext!).pop();
        } catch (_) {}
      }

      if (context.mounted) {
        // Show specific error message
        String errorTitle;
        String errorMessage;

        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorTitle = 'Wrong Password';
          errorMessage =
              'The password you entered is incorrect. Please try again.';
        } else if (e.code == 'too-many-requests') {
          errorTitle = 'Too Many Attempts';
          errorMessage =
              'You have made too many failed attempts. Please try again later.';
        } else {
          errorTitle = 'Authentication Error';
          errorMessage =
              e.message ?? 'An error occurred during authentication.';
        }

        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                errorMessage,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Close loading dialog using its own context
      if (loadingContext != null) {
        try {
          Navigator.of(loadingContext!).pop();
        } catch (_) {}
      }

      if (context.mounted) {
        // Show error message
        ModernSnackBar.show(
          context,
          'Error deleting account: ${e.toString()}',
          type: SnackBarType.error,
          duration: Duration(seconds: 4),
        );
      }
    }
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: label == 'Delete Account'
                          ? Colors.red
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
