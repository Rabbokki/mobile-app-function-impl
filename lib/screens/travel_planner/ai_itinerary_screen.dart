import 'package:flutter/material.dart';

class AiItineraryScreen extends StatefulWidget {
  const AiItineraryScreen({super.key});

  @override
  State<AiItineraryScreen> createState() => _AiItineraryScreenState();
}

class _AiItineraryScreenState extends State<AiItineraryScreen> {
  double budgetLevel = 0.5;
  double paceLevel = 0.5;

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('AI 추천 일정 만들기'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '여행 선호도',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '예: 역사 유적지를 좋아하고, 자연 경관을 즐깁니다.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '예산 수준',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: budgetLevel,
              onChanged: (value) {
                setState(() {
                  budgetLevel = value;
                });
              },
              divisions: 2,
              label: budgetLevel < 0.34
                  ? '저예산'
                  : (budgetLevel < 0.67 ? '중간' : '고예산'),
              activeColor: travelingPurple,
            ),
            const SizedBox(height: 24),
            const Text(
              '여행 페이스',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: paceLevel,
              onChanged: (value) {
                setState(() {
                  paceLevel = value;
                });
              },
              divisions: 2,
              label: paceLevel < 0.34
                  ? '여유롭게'
                  : (paceLevel < 0.67 ? '균형있게' : '바쁘게'),
              activeColor: travelingPurple,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/step5');
                },
                child: const Text('AI 일정 생성하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
