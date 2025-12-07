import 'package:flutter/material.dart';

class EnhancedTripCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String price;
  final String status;
  final Color color;
  final VoidCallback onShowDetails;

  const EnhancedTripCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    required this.color,
    required this.onShowDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
        top: screenHeight * 0.148,
        bottom: 12,
      ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),

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

                const SizedBox(height: 10),

                // Enhanced action button
                Container(
                  width: screenWidth * 0.42,
                  height: screenHeight * 0.049,
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
                    onPressed: onShowDetails,
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
                      "Show details",
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
                width: screenHeight * 0.14,
                height: screenHeight * 0.14,
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
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
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
    Color themeColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeColor.withOpacity(0.05), themeColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: themeColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: themeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
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
