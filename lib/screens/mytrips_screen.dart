import 'package:flutter/material.dart';
import 'package:mob_project/screens/main_screen.dart';
import 'package:mob_project/screens/ticket_screen.dart';
import 'package:mob_project/widgets/custom_bottom_nav.dart';

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
      
    
      body: Padding(
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
}

class TripCard extends StatelessWidget {
  final String image;
  final String status;
  final String location;
  final String dateRange;
  final String people;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;

  const TripCard({
    required this.image,
    required this.status,
    required this.location,
    required this.dateRange,
    required this.people,
    required this.buttonText,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: status == 'UPCOMING' ? Colors.blue : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.date_range, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(dateRange, style: TextStyle(fontSize: 12)),
                    Spacer(),
                    Icon(Icons.people, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(people, style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: textColor ?? Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TicketPage(bookingId: '1',)),
                    );},
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

