import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF5FF), // 연보라색 배경
      body: Column(
        children: [
          Image.asset(
            'assets/images/heroBanner2.png',
            fit: BoxFit.cover,
          ),

        ],
      ),
    );
  }
}
