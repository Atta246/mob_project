import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../home/main_screen.dart';
import 'package:mob_project/utils/validators.dart';
import 'package:mob_project/services/profile_service.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isInitializing = true;

  bool _isFullNameEditable = false;
  bool _isUsernameEditable = false;
  bool _isPhoneEditable = false;

  String? _fullNameError;
  String? _usernameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _profileService.loadUserData();
      if (user != null) {
        setState(() {
          _fullNameController.text = user.fullName;
          _usernameController.text = user.username ?? '';
          _phoneController.text = user.phoneNumber ?? '';
          _isInitializing = false;
        });
      } else {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isInitializing = false;
      });
      if (mounted) {
        ModernSnackBar.show(
          context,
          'Error loading profile: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    // Validate all fields
    setState(() {
      _fullNameError = Validators.validateFullName(_fullNameController.text);
      _usernameError = Validators.validateProfileUsername(
        _usernameController.text,
      );
      _phoneError = Validators.validatePhone(_phoneController.text);
    });

    // Check if validation passed
    if (_fullNameError != null ||
        _usernameError != null ||
        _phoneError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _profileService.updateProfile(
        fullName: _fullNameController.text,
        username: _usernameController.text,
        phoneNumber: _phoneController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ModernSnackBar.show(
          context,
          'Profile updated successfully!',
          type: SnackBarType.success,
          duration: const Duration(seconds: 2),
        );

        // Go back to previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ModernSnackBar.show(
          context,
          'Error updating profile: ${e.toString()}',
          type: SnackBarType.error,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableField(
                          Icons.person_outline,
                          'Full Name',
                          _fullNameController,
                          _isFullNameEditable,
                          () {
                            setState(() {
                              _isFullNameEditable = !_isFullNameEditable;
                            });
                          },
                          (value) {
                            setState(() {
                              _fullNameError = Validators.validateFullName(
                                value,
                              );
                            });
                          },
                        ),
                        if (_fullNameError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _fullNameError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableField(
                          Icons.alternate_email,
                          'Username',
                          _usernameController,
                          _isUsernameEditable,
                          () {
                            setState(() {
                              _isUsernameEditable = !_isUsernameEditable;
                            });
                          },
                          (value) {
                            setState(() {
                              _usernameError =
                                  Validators.validateProfileUsername(value);
                            });
                          },
                        ),
                        if (_usernameError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _usernameError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReadOnlyField(
                          Icons.email_outlined,
                          'Email',
                          _profileService.getCurrentUserEmail() ?? 'N/A',
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableField(
                          Icons.phone_outlined,
                          'Phone Number',
                          _phoneController,
                          _isPhoneEditable,
                          () {
                            setState(() {
                              _isPhoneEditable = !_isPhoneEditable;
                            });
                          },
                          (value) {
                            setState(() {
                              _phoneError = Validators.validatePhone(value);
                            });
                          },
                        ),
                        if (_phoneError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _phoneError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16),
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

  Widget _buildEditableField(
    IconData icon,
    String label,
    TextEditingController controller,
    bool isEditable,
    VoidCallback onEditTap,
    void Function(String)? onChanged,
  ) {
    return Container(
      constraints: BoxConstraints(minHeight: 70),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: null,
      decoration: BoxDecoration(
        color: isEditable ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: controller,
                  onChanged: onChanged,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: isEditable ? Colors.black87 : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEditTap,
            child: Icon(
              isEditable ? Icons.check_circle : Icons.edit_outlined,
              color: isEditable ? Colors.green : Colors.lightBlue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(IconData icon, String label, String value) {
    return Container(
      constraints: BoxConstraints(minHeight: 70),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: null,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_outline, color: Colors.grey[500], size: 20),
        ],
      ),
    );
  }
}
