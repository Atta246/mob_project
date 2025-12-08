import 'package:flutter/material.dart';
import 'package:mob_project/screens/home/main_screen.dart';
import 'package:mob_project/widgets/widgets.dart';

class MyTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trips'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              TripCard(
                image: 'assets/images/ballon.png',
                status: 'UPCOMING',
                location: 'Egypt, Luxor',
                dateRange: 'Sep 15 - Sep 22, 2026',
                people: '2 people',
                buttonText: 'View Details',
                buttonColor: Colors.blue,
              ),
              SizedBox(height: 16),
              TripCard(
                image: 'assets/images/ballon.png',
                status: 'UPCOMING',
                location: 'Egypt, Luxor',
                dateRange: 'Jul 10 - Jul 18, 2026',
                people: '4 people',
                buttonText: 'View Details',
                buttonColor: Colors.blue,
              ),
            ],
          ),
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
}
