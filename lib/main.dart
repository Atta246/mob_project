import 'package:flutter/material.dart';
import 'package:mob_project/screens/Settings%20screens/Profile_screen.dart';
import 'package:mob_project/screens/home_screen.dart';
import 'package:mob_project/screens/login_screen.dart';
import 'package:mob_project/screens/signup_screen.dart';
import 'package:mob_project/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'skyfly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const loginScreen(),
    );
  }
}
