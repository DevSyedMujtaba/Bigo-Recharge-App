import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../home/home_root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeRootScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bigo-recharge-logo1.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            const Text(
              'BIGO RECHARGE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B338B),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 