import 'package:flutter/material.dart';

class AiItineraryScreen extends StatefulWidget {
  const AiItineraryScreen({super.key});

  @override
  State<AiItineraryScreen> createState() => _AiItineraryScreenState();
}

class _AiItineraryScreenState extends State<AiItineraryScreen> {
  double budgetLevel = 0.5;
  double paceLevel = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 추천 일정 만들기'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('여행 선호도'),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '예: 역사 유적지를 좋아하고, 자연 경관을 즐깁니다.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('예산 수준'),
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
            ),
            const SizedBox(height: 20),
            const Text('여행 페이스'),
            Slider(
              value: paceLevel,
              onChanged: (value) {
                setState(() {
                  paceLevel = value;
                });
              },
              divisions: 2,
              label:
              paceLevel < 0.34 ? '여유롭게' : (paceLevel < 0.67 ? '균형있게' : '빡세게'),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
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
