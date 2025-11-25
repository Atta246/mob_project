import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField(
              Icons.person_outline,
              'User Name',
              'Ahmed Ragab',
            ),
            SizedBox(height: 16),
            _buildInputField(
              Icons.email_outlined,
              'Email',
              'Ahmed@gmail.com',
            ),
            SizedBox(height: 16),
            _buildInputField(
              Icons.phone_outlined,
              'Phone Number',
              '+201000000000',
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  print('Save tapped');
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
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.popUntil(context, (route) => route.isFirst);
              break;
            case 1:
              Navigator.popUntil(context, (route) => route.isFirst);
              break;
            case 2:
              Navigator.popUntil(context, (route) => route.isFirst);
              break;
          }
        },
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label, String value) {
    return Container(
      height: 85,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
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
