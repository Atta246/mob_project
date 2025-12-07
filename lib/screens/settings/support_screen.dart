import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import 'Profile_screen.dart';
import 'contact_us_screen.dart';
import '../home/main_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
              () {
                print('Email Us tapped');
              },
            ),
            SizedBox(height: 12),
            _buildContactItem(
              Icons.phone_outlined,
              'Call Us',
              Colors.lightBlue,
              () {
                print('Call Us tapped');
              },
            ),
            SizedBox(height: 12),
            _buildContactItem(
              Icons.chat_outlined,
              'Live Chat',
              Colors.lightBlue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()),
                );
              },
            ),
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
              print('Give Feedback tapped');
            }),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            Navigator.popUntil(context, (route) => route.isFirst);
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
