import 'package:flutter/material.dart';

class TripModeSelectScreen extends StatelessWidget {
  final String selectedCity;

  const TripModeSelectScreen({super.key, required this.selectedCity});

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFFA78BFA);
    const Color orange = Color(0xFFFF8F5C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 방식 선택'),
        backgroundColor: purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '$selectedCity 여행을 어떻게 만들까요?',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // 나의 여행 만들기 카드
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/step1',
                  arguments: {'city': selectedCity},
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: purple),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_calendar, color: purple, size: 32),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '나의 여행 만들기\n원하는 날짜와 장소를 직접 선택해요.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // AI 추천 일정 만들기 카드
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/ai_itinerary',
                  arguments: {'city': selectedCity},
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'AI 추천 일정 만들기\n선호도 기반으로 일정을 추천받아요.',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
