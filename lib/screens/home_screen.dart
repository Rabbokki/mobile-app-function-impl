import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF5FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/heroBanner2.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // 항공권 이동 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/flight');
              },
              child: const Text('항공권 검색'),
            ),

            const SizedBox(height: 10),

            // 추천 명소 이동 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recommended');
              },
              child: const Text('추천 명소 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
