import 'package:flutter/material.dart';
import 'package:mob_project/screens/home_screen.dart';
import 'package:mob_project/screens/trips_screen.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _selectedIndex = 0;

  // Colors extracted from design
  final Color _bottomNavColor = const Color(0xFF90E0FF);

  @override
  Widget build(BuildContext context) {
    // Determine which body to show based on selected index
    Widget currentBody;
    switch (_selectedIndex) {
      case 0:
        currentBody = const homeScreen();
        break;
      case 1:
        currentBody = const tripsScreen();
        break;
      case 2:
      default:
        currentBody = const Center(child: Text("Profile Page Placeholder"));
        break;
    }

    return Scaffold(
      // We remove backgroundColor here because TripsTab needs its own background image
      body: currentBody,

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: _bottomNavColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'assets/images/home_icon.png', "HOME"),
            _buildNavItem(1, 'assets/images/trips_icon.png', "TRIPS"),
            _buildNavItem(2, 'assets/images/profile_icon.png', "PROFILE"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent, // Hit test target area
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 28,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
