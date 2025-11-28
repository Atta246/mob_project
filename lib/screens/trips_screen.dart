import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mob_project/screens/trip_details_screen.dart';

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
                height: 200,
                child: Stack(
                  children: [
                    // Animated floating balloons
                    ...List.generate(
                      8,
                      (index) => _buildAnimatedBalloon(index),
                    ),

                    // Header content
                    Positioned.fill(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Logo with glow effect
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/blue_logo.png',
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Enhanced title
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced Trip Cards with PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildEnhancedTripCard(
                      imagePath: 'assets/images/ballon1.png',
                      title: "🌅 Golden Sunrise Journey",
                      subtitle: "Chase the dawn above the clouds",
                      date: "May 24, 2024",
                      time: "5:30 AM",
                      price: "120",
                      status: "Completed",
                      color: const Color(0xFFFFB347),
                    ),
                    _buildEnhancedTripCard(
                      imagePath: 'assets/images/ballon2.png',
                      title: "🌞 Bright Morning Flight",
                      subtitle: "Soar through the morning light",
                      date: "June 25, 2024",
                      time: "7:00 AM",
                      price: "150",
                      status: "Upcoming",
                      color: const Color(0xFF87CEEB),
                    ),
                    _buildEnhancedTripCard(
                      imagePath: 'assets/images/ballon.png',
                      title: "🌄 Majestic Dawn Adventure",
                      subtitle: "Experience the magic of sunrise",
                      date: "August 12, 2024",
                      time: "6:00 AM",
                      price: "100",
                      status: "Completed",
                      color: const Color(0xFFDDA0DD),
                    ),
                  ],
                ),
              ),

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

  Widget _buildEnhancedTripCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String date,
    required String time,
    required String price,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main card with glassmorphism effect
          Container(
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.fromLTRB(25, 70, 25, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Title with enhanced styling
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),

                // Enhanced info cards
                _buildInfoCard(Icons.access_time_rounded, "Time", time, color),
                const SizedBox(height: 10),
                _buildInfoCard(
                  Icons.calendar_month_rounded,
                  "Date",
                  date,
                  color,
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  Icons.attach_money_rounded,
                  "Price",
                  "\$$price",
                  color,
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  status == "Completed"
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  "Status",
                  status,
                  status == "Completed" ? Colors.green : Colors.orange,
                ),

                const SizedBox(height: 20),

                // Enhanced action button
                Container(
                  width: 160,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TripDetailsPage(tripId: "1")),
                        ); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(
                      Icons.airplane_ticket_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "VIEW TICKET",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating circular image with enhanced styling
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.9)],
                  ),
                  border: Border.all(color: color, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
