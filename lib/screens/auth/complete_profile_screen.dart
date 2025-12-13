import 'package:flutter/material.dart';
import 'package:mob_project/screens/home/main_screen.dart';
import 'package:mob_project/utils/validators.dart';
import 'package:mob_project/services/profile_service.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isInitializing = true;

  String? _fullNameError;
  String? _usernameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
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
        // Pre-fill with Firebase Auth data if available
        final displayInfo = _profileService.getCurrentUserDisplayInfo();
        if (displayInfo != null) {
          _fullNameController.text = displayInfo;
        }
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isInitializing = false;
      });
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
      await _profileService.completeProfile(
        fullName: _fullNameController.text,
        username: _usernameController.text,
        phoneNumber: _phoneController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ModernSnackBar.show(
          context,
          'Profile completed successfully!',
          type: SnackBarType.success,
          duration: const Duration(seconds: 2),
        );

        // Navigate to main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const mainScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ModernSnackBar.show(
          context,
          'Error saving profile: ${e.toString()}',
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Top blue header
              SizedBox(
                height: screenHeight * 0.37,
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.lightBlue,
                  toolbarHeight: screenHeight * 0.3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(60),
                    ),
                  ),
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Complete Your Profile',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please fill in your information',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Form card
              Positioned(
                top: screenHeight * 0.2 - 50,
                left: screenWidth * 0.05,
                width: screenWidth * 0.9,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile icon
                              Center(
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.lightBlue.shade100,
                                  child: const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Email (read-only)
                              const Text(
                                'EMAIL',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _profileService.getCurrentUserEmail() ??
                                      'N/A',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Full Name
                              const Text(
                                'FULL NAME',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _fullNameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'First Last (e.g., Ahmed Mohamed)',
                                  errorText: _fullNameError,
                                  contentPadding: const EdgeInsets.all(13),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _fullNameError =
                                        Validators.validateFullName(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Username
                              const Text(
                                'USERNAME',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText:
                                      'Choose a username (e.g., ahmed_123)',
                                  errorText: _usernameError,
                                  contentPadding: const EdgeInsets.all(13),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _usernameError =
                                        Validators.validateProfileUsername(
                                          value,
                                        );
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Phone Number
                              const Text(
                                'PHONE NUMBER',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: '+20 XXX XXX XXXX',
                                  errorText: _phoneError,
                                  contentPadding: const EdgeInsets.all(13),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _phoneError = Validators.validatePhone(
                                      value,
                                    );
                                  });
                                },
                              ),
                              const SizedBox(height: 24),

                              // Save button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          'Complete Profile',
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
