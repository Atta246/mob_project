import 'package:flutter/material.dart';
import 'package:mob_project/screens/trips/booking_screen.dart';
import 'package:mob_project/widgets/widgets.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final PageController _pageController = PageController();
  int _currentCarouselIndex = 0;
  final Color _cardBackgroundColor = const Color(0xFFF0F9FF);
  final Color _bookBtnColor = const Color(0xFF90E0FF);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Center(
              child: Image.asset(
                'assets/images/blue_logo.png',
                height: MediaQuery.of(context).size.height * 0.08,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Carousel
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _currentCarouselIndex = index),
                      children: [
                        _buildCarouselItem(
                          'assets/images/ballon.png',
                          "Where the sky\nmeets your\ndreams.",
                        ),
                        _buildCarouselItem(
                          'assets/images/ballon1.png',
                          "Experience the\nmagic of flight.",
                        ),
                        _buildCarouselItem(
                          'assets/images/ballon2.png',
                          "Adventure\nawaits you.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 25),
                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Popular Tips",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        HomeTripCard(
                          imagePath: 'assets/images/ballon1.png',
                          title: "Sunrise Trip",
                          description:
                              "Our most popular adventure—watch the sunrise paint the sky from a floating balloon.",
                          tripId: 'sunrise_trip',
                          onBookNow: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingPage(tripId: 'sunrise_trip'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        HomeTripCard(
                          imagePath: 'assets/images/ballon2.png',
                          title: "After Sunrise Trip",
                          description:
                              "Golden skies, quiet winds, and a perfect sunrise—our most unforgettable trip.",
                          tripId: 'after_sunrise_trip',
                          onBookNow: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingPage(tripId: 'after_sunrise_trip'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
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

  Widget _buildCarouselItem(String imagePath, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.black.withOpacity(0.3), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.only(left: 25, bottom: 25),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 5,
                color: Colors.black45,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: _currentCarouselIndex == index
            ? const Color(0xFF64B5F6)
            : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
