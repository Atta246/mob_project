import 'package:flutter/material.dart';
import 'package:mob_project/screens/home.dart';
import 'package:mob_project/screens/home_screen.dart';
import 'package:mob_project/screens/trips_screen.dart';
import 'package:mob_project/screens/Settings%20screens/Profile_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class mainScreen extends StatefulWidget {
  final int initialIndex;
  const mainScreen({super.key, this.initialIndex = 0});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // Determine which body to show based on selected index
    Widget currentBody;
    switch (_selectedIndex) {
      case 0:
        currentBody = const HomePage();
        break;
      case 1:
        currentBody = const tripsScreen();
        break;
      case 2:
        currentBody = const Setting_page();
        break;
      default:
        currentBody = const homeScreen();
        break;
    }

    return Scaffold(
      body: currentBody,

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
