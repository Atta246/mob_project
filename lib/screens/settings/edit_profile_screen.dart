import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../home/main_screen.dart';
import 'package:mob_project/utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Ahmed Ragab',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'Ahmed@gmail.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+201000000000',
  );
  String? _nameError;
  String? _emailError;
  String? _phoneError;

  @override
  Widget build(BuildContext context) {
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
                        _buildInputField(
                          Icons.person_outline,
                          'User Name',
                          _nameController,
                          (value) {
                            setState(() {
                              _nameError = Validators.validateName(value);
                            });
                          },
                        ),
                        if (_nameError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _nameError!,
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
                        _buildInputField(
                          Icons.email_outlined,
                          'Email',
                          _emailController,
                          (value) {
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
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                          Icons.phone_outlined,
                          'Phone Number',
                          _phoneController,
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
                        onPressed: () {
                          // Validate all fields
                          setState(() {
                            _nameError = Validators.validateName(
                              _nameController.text,
                            );
                            _emailError = Validators.validateEmail(
                              _emailController.text,
                            );
                            _phoneError = Validators.validatePhone(
                              _phoneController.text,
                            );
                          });

                          // Check if validation passed
                          if (_nameError == null &&
                              _emailError == null &&
                              _phoneError == null) {
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
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

  Widget _buildInputField(
    IconData icon,
    String label,
    TextEditingController controller,
    void Function(String)? onChanged,
  ) {
    return Container(
      constraints: BoxConstraints(minHeight: 70),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: null,
      decoration: BoxDecoration(
        color: Colors.white,
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: Colors.lightBlue, size: 20),
        ],
      ),
    );
  }
}
