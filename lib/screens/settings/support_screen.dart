import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mob_project/services/feedback_service.dart';
import 'package:mob_project/utils/modern_snackbar.dart';
import '../../widgets/widgets.dart';
import '../home/main_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _launchEmail() async {
    final String subject = 'Support Request';
    final String email = 'ahmedbod50@gmail.com';

    // Gmail specific URI (mainly for iOS)
    final Uri gmailUri = Uri.parse(
      'googlegmail:///co?to=$email&subject=${Uri.encodeComponent(subject)}',
    );

    // Standard mailto URI (Android/iOS fallback)
    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{'subject': subject}),
    );

    try {
      // Try to launch Gmail app directly (works on iOS if installed)
      // On Android, this scheme might not be handled, so it will fall through
      if (!await launchUrl(gmailUri)) {
        // Fallback to default email app (opens Gmail on Android if it's default/selected)
        if (!await launchUrl(mailtoUri)) {
          debugPrint('Could not launch email client');
        }
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
      // Last resort fallback
      try {
        await launchUrl(mailtoUri);
      } catch (_) {}
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: '01099844825');

    try {
      if (!await launchUrl(phoneLaunchUri)) {
        debugPrint('Could not launch phone dialer');
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Support'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildContactItem(
              Icons.email_outlined,
              'Email Us',
              Colors.lightBlue,
              () => _launchEmail(),
            ),
            SizedBox(height: 12),
            _buildContactItem(
              Icons.phone_outlined,
              'Call Us',
              Colors.lightBlue,
              () => _launchPhone(),
            ),
            SizedBox(height: 12),
            SizedBox(height: 24),
            Text(
              'Feedback',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            _buildFeedbackItem('Give Feedback', Icons.edit_outlined, () {
              _showFeedbackDialog(context);
            }),
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

  Future<void> _showFeedbackDialog(BuildContext parentContext) async {
    final TextEditingController feedbackController = TextEditingController();
    final FeedbackService feedbackService = FeedbackService();

    return showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Give Feedback',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We would love to hear your thoughts!',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Type your feedback here...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final feedback = feedbackController.text.trim();
                          if (feedback.isEmpty) return;

                          setState(() => isLoading = true);

                          try {
                            await feedbackService.submitFeedback(feedback);
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                            if (parentContext.mounted) {
                              ModernSnackBar.show(
                                parentContext,
                                'Thank you for your feedback!',
                                type: SnackBarType.success,
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);
                            // Show error on the dialog context if possible, or parent
                            // Since dialog is still open, we can show it there or just use parent
                            // But ModernSnackBar usually attaches to Scaffold.
                            // Let's try showing on parentContext but keep dialog open
                            if (parentContext.mounted) {
                              ModernSnackBar.show(
                                parentContext,
                                'Error submitting feedback: $e',
                                type: SnackBarType.error,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
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
                    style: TextStyle(fontSize: 16, color: Colors.black87),
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

  Widget _buildFeedbackItem(
    String label,
    IconData trailingIcon,
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
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                Icon(trailingIcon, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
