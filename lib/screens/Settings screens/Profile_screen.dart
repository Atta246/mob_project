import 'package:flutter/material.dart';
import 'package:mob_project/screens/Settings%20screens/support_screen.dart';
import 'package:mob_project/screens/mytrips_screen.dart';
import 'package:mob_project/screens/payment_screen.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'settings_screen.dart';

class Setting_page extends StatelessWidget {
  const Setting_page({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            clipBehavior: Clip.none,

            children: [
              SizedBox(
                height: screenHeight * 0.37,
                child: AppBar(
                  backgroundColor: Colors.lightBlue,
                  toolbarHeight: screenHeight * 0.3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(60),
                    ),
                  ),
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(left: 20, top: 56),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hi, Ahmed',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.2 - 50,
                left: screenwidth * 0.05,
                width: screenwidth * 0.9,

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    alignment: Alignment.center,
                    height: screenHeight * 0.42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 56,
                                child: Icon(
                                  Icons.person,
                                  size: 70,
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Ahmed',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                       
                        Text(
                          'EMAIL',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ahmed@gmail.com',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 10),

                        Text(
                          'PHONE NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '0000000000',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 16),
                      _buildMenuItem(Icons.card_travel, 'My Trips', () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyTripsScreen()),
                        );
                      }),
                      SizedBox(height: 12),
                      _buildMenuItem(Icons.settings, 'Settings', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsDetailScreen()),
                        );
                      }),
                      SizedBox(height: 12),
                      _buildMenuItem(Icons.support_agent, 'Support', (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SupportScreen()),
                        );
                      }),
                    ],
                  )
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

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Container(
      
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
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
                Icon(icon, color: Colors.grey[700], size: 28),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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
