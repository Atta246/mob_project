import 'package:flutter/material.dart';
import 'package:mob_project/screens/trip_details_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6FF),
      //nav bar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(), // .....................Top header
            const SizedBox(height: 20),
            const Slides(), //.................. Slides
            const SizedBox(height: 30),
            PopularTips(context), // .........Popular tips/trip section
          ],
        ),
      ),
    );
  }

  // ........................................................................................Header Widget

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sky Fly", // Main app header
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Welcome, areej!", // Welcome text
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  //.................................................................................. Popular Tips Section

  Widget PopularTips(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Tips",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SunriseTrip(context), // Sunrise trip details and back ground
      ],
    );
  }

  // ....................................................................................Trip Card Widget

  Widget SunriseTrip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF), //  white-blue
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/Balloon11.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Sunrise Trip", // Trip title
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Our most popular adventure — watch the sunrise paint the sky from a floating balloon.",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          // Book button aligned to the right
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripDetailsPage(tripId: '1'),
                  ),
                );
              }, //  booking pagee
              child: const Text(
                "BOOK NOW",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // .................................................................................. Nav Bar
}

// ------------------------------------------------------..........................Top_Bar Carousel Widget

class Slides extends StatefulWidget {
  const Slides({super.key});

  @override
  State<Slides> createState() => SlidesState();
}

class SlidesState extends State<Slides> {
  int _currentPage = 0;

  // swar el slides
  final List<String> images = [
    "assets/images/Balloon77.png",
    "assets/images/Balloon44.png",
    "assets/images/Balloon33.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView for horizontal swiping
        SizedBox(
          height: 200,
          child: PageView(
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: images.map((img) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        // Row of dots indicating current page
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
