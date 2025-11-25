import 'package:flutter/material.dart';

class tripsScreen extends StatefulWidget {
  const tripsScreen({super.key});

  @override
  State<tripsScreen> createState() => _tripsScreenState();
}

class _tripsScreenState extends State<tripsScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    // Background Image
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // PageView for horizontal scroll
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                padEnds: false,
                children: [
                  _buildFloatingTripCard(
                    imagePath: 'assets/images/ballon.png',
                    title: "SUNRISE TRIP",
                    subtitle: "\"Start your day above the clouds\"",
                    time: "From 5 : 7 Am",
                    location: "Luxor, Egypt",
                    price: "\$120 per person",
                    passengers: "Up to 4 people",
                  ),
                  _buildFloatingTripCard(
                    imagePath: 'assets/images/ballon1.png',
                    title: "MORNING LIGHT TRIP",
                    subtitle: "\"Fly with the soft morning glow\"",
                    time: "From 7 : 9 Am",
                    location: "Luxor, Egypt",
                    price: "\$100 per person",
                    passengers: "Up to 8 people",
                  ),
                  _buildFloatingTripCard(
                    imagePath: 'assets/images/ballon2.png',
                    title: "BRIGHT SUN TRIP",
                    subtitle: "\"Feel the thrill of the bright sky\"",
                    time: "From 9 : 11 Am",
                    location: "Luxor, Egypt",
                    price: "\$90 per person",
                    passengers: "Up to 16 people",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTripCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String time,
    required String location,
    required String price,
    required String passengers,
  }) {
    // Larger circular design
    const double circleRadius = 90;
    const double cardHeight = 450;
    const double imageTopOffset = 20;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Main Card Container - More circular/rounded
          Container(
            margin: const EdgeInsets.only(top: circleRadius + imageTopOffset),
            height: cardHeight - circleRadius - imageTopOffset+20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 80, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Details List with better spacing
                  _buildDetailRow(time),
                  const SizedBox(height: 12),
                  _buildDetailRow(location),
                  const SizedBox(height: 12),
                  _buildDetailRow(price),
                  const SizedBox(height: 12),
                  _buildDetailRow(passengers),
                  const SizedBox(height: 12),

                  const Spacer(),

                  // Book Button - More prominent
                  Container(
                    width: 120,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF90E0FF), Color(0xFF7DD3FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF90E0FF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      
                      child: const Text(
                        "BOOK NOW",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),

          // Floating Circular Image - Larger and more prominent
          Positioned(
            top: imageTopOffset,
            child: Container(
              width: circleRadius * 2,
              height: circleRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: circleRadius * 2,
                  height: circleRadius * 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String text) {
    return Row(
      children: [
        // Custom Arrow Bullet Point
        Image.asset(
          'assets/images/arrow.png',
          width: 16,
          height: 16,
          color: const Color(0xFF90E0FF), // Tint it to match theme if needed
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),
        ),
      ],
    );
  }
}
