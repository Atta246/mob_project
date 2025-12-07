import 'package:flutter/material.dart';
import 'package:mob_project/screens/auth/login_screen.dart';
import 'package:mob_project/screens/trips/payment_screen.dart';
import 'package:mob_project/screens/auth/signup_screen.dart';
import 'package:mob_project/screens/home/main_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 124, 193, 246),
        ),
      ),
      home: const loginScreen(),
    );
  }
}
