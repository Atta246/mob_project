import 'package:flutter/material.dart';
import 'package:mob_project/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mob_project/models/models.dart';
import 'package:mob_project/repositories/repositories.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _messageError;
  final SupportRepository _supportRepository = SupportRepository();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: Container(color: Colors.grey[100])),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _messageController,
                          onChanged: (value) {
                            setState(() {
                              _messageError = Validators.validateMessage(value);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (_messageError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _messageError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: _isSending
                        ? Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              // Validate message
                              setState(() {
                                _messageError = Validators.validateMessage(
                                  _messageController.text,
                                );
                              });

                              // Check if validation passed
                              if (_messageError == null) {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser == null) {
                                  ModernSnackBar.show(
                                    context,
                                    'Please login to send a message',
                                    type: SnackBarType.warning,
                                  );
                                  return;
                                }

                                setState(() {
                                  _isSending = true;
                                });

                                try {
                                  // Create support message
                                  final message = SupportMessageModel(
                                    messageId: '',
                                    userId: currentUser.uid,
                                    name: currentUser.displayName ?? 'User',
                                    email: currentUser.email ?? '',
                                    subject: 'Contact Us',
                                    message: _messageController.text.trim(),
                                    status: 'open',
                                    createdAt: DateTime.now(),
                                  );

                                  await _supportRepository.createSupportMessage(
                                    message,
                                  );

                                  // Show success message
                                  if (mounted) {
                                    ModernSnackBar.show(
                                      context,
                                      'Message sent successfully!',
                                      type: SnackBarType.success,
                                    );
                                    // Clear message
                                    _messageController.clear();
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ModernSnackBar.show(
                                      context,
                                      'Failed to send message: $e',
                                      type: SnackBarType.error,
                                    );
                                  }
                                } finally {
                                  setState(() {
                                    _isSending = false;
                                  });
                                }
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
