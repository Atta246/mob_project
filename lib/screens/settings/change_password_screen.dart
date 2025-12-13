import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../home/main_screen.dart';
import 'package:mob_project/utils/validators.dart';
import 'package:mob_project/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ProfileService _profileService = ProfileService();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword() async {
    // Validate all fields
    setState(() {
      _oldPasswordError = Validators.validatePassword(
        _oldPasswordController.text,
      );
      _newPasswordError = Validators.validatePassword(
        _newPasswordController.text,
      );
      _confirmPasswordError = Validators.validateConfirmPassword(
        _confirmPasswordController.text,
        _newPasswordController.text,
      );
    });

    // Check if validation passed
    if (_oldPasswordError != null ||
        _newPasswordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _profileService.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ModernSnackBar.show(
          context,
          'Password changed successfully!',
          type: SnackBarType.success,
          duration: const Duration(seconds: 2),
        );

        // Clear fields and go back
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = 'Old password is incorrect';
        setState(() {
          _oldPasswordError = errorMessage;
        });
      } else if (e.code == 'weak-password') {
        errorMessage = 'New password is too weak';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Please log out and log in again to change password';
      } else {
        errorMessage = 'Failed to change password: ${e.message}';
      }

      if (mounted) {
        ModernSnackBar.show(
          context,
          errorMessage,
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

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordField(
                          icon: Icons.lock_outline,
                          label: 'Current Password',
                          controller: _oldPasswordController,
                          isVisible: _isOldPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isOldPasswordVisible = !_isOldPasswordVisible;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _oldPasswordError = Validators.validatePassword(
                                value,
                              );
                            });
                          },
                        ),
                        if (_oldPasswordError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: Colors.red[700],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  _oldPasswordError!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordField(
                          icon: Icons.lock_outline,
                          label: 'New Password',
                          controller: _newPasswordController,
                          isVisible: _isNewPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _newPasswordError = Validators.validatePassword(
                                value,
                              );
                            });
                          },
                        ),
                        if (_newPasswordError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: Colors.red[700],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  _newPasswordError!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordField(
                          icon: Icons.lock_outline,
                          label: 'Confirm New Password',
                          controller: _confirmPasswordController,
                          isVisible: _isConfirmPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _confirmPasswordError =
                                  Validators.validateConfirmPassword(
                                    value,
                                    _newPasswordController.text,
                                  );
                            });
                          },
                        ),
                        if (_confirmPasswordError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: Colors.red[700],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  _confirmPasswordError!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Spacer(),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.lightBlue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Update Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
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

  Widget _buildPasswordField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required void Function(String) onChanged,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 68),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.lightBlue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  obscureText: !isVisible,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 22,
              color: Colors.grey[600],
            ),
            onPressed: onVisibilityToggle,
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
}
