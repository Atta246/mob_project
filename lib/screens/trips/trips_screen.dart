import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mob_project/screens/trips/trip_details_screen.dart';
import 'package:mob_project/widgets/widgets.dart';

class tripsScreen extends StatefulWidget {
  const tripsScreen({super.key});

  @override
  State<tripsScreen> createState() => _tripsScreenState();
}

class _tripsScreenState extends State<tripsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue at top
              Color(0xFFB8E6FF), // Light blue
              Color(0xFFE0F6FF), // Very light blue
              Color(0xFFF0F9FF), // Almost white blue
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header with floating balloons
              Container(
                height: MediaQuery.of(context).size.height * 0.825,
                child: Stack(
                  children: [
                    // Animated floating balloons

                    // Header content
                    Positioned.fill(
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              "✈️ My Sky Adventures",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E3A8A),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          // Logo with glow effect
                          //  const SizedBox(height: 15),
                          // Enhanced title
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          EnhancedTripCard(
                            imagePath: 'assets/images/ballon1.png',
                            title: "🌅 Golden Sunrise Journey",
                            subtitle: "Chase the dawn above the clouds",
                            date: "May 24, 2024",
                            time: "5:30 AM",
                            price: "120",
                            status: "Completed",
                            color: const Color(0xFFFFB347),
                            onShowDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TripDetailsPage(tripId: "1"),
                                ),
                              );
                            },
                          ),
                          EnhancedTripCard(
                            imagePath: 'assets/images/ballon2.png',
                            title: "🌞 Bright Morning Flight",
                            subtitle: "Soar through the morning light",
                            date: "June 25, 2024",
                            time: "7:00 AM",
                            price: "150",
                            status: "Upcoming",
                            color: const Color(0xFF87CEEB),
                            onShowDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TripDetailsPage(tripId: "2"),
                                ),
                              );
                            },
                          ),
                          EnhancedTripCard(
                            imagePath: 'assets/images/ballon.png',
                            title: "🌄 Majestic Dawn ",
                            subtitle: "Experience the magic of sunrise",
                            date: "August 12, 2024",
                            time: "6:00 AM",
                            price: "100",
                            status: "Upcoming",
                            color: const Color(0xFFDDA0DD),
                            onShowDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TripDetailsPage(tripId: "3"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced Trip Cards with PageView
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Enhanced bottom navigation
    );
  }

  Widget _buildAnimatedBalloon(int index) {
    final positions = [
      const Offset(50, 30),
      const Offset(300, 20),
      const Offset(200, 60),
      const Offset(80, 80),
      const Offset(250, 100),
      const Offset(150, 40),
      const Offset(320, 70),
      const Offset(30, 120),
    ];

    final colors = [
      Colors.orange.withOpacity(0.7),
      Colors.purple.withOpacity(0.7),
      Colors.green.withOpacity(0.7),
      Colors.red.withOpacity(0.7),
      Colors.blue.withOpacity(0.7),
      Colors.pink.withOpacity(0.7),
      Colors.yellow.withOpacity(0.7),
      Colors.indigo.withOpacity(0.7),
    ];

    final sizes = [25.0, 35.0, 20.0, 30.0, 28.0, 22.0, 33.0, 26.0];

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          left:
              positions[index].dx +
              (5 * sin(_animationController.value * 2 * 3.14159 + index)),
          top:
              positions[index].dy +
              (3 * cos(_animationController.value * 2 * 3.14159 + index)),
          child: Container(
            width: sizes[index],
            height: sizes[index] * 1.2,
            child: Column(
              children: [
                Container(
                  width: sizes[index],
                  height: sizes[index],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [colors[index], colors[index].withOpacity(0.4)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors[index].withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.5,
                  height: sizes[index] * 0.15,
                  color: Colors.brown.withOpacity(0.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            size: 26,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
