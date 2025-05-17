import 'package:flutter/material.dart';

class FlightResultScreen extends StatelessWidget {
  const FlightResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('항공권 검색 결과'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: 5, // 예시로 5개 항공권 결과
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '대한항공 (KE123)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('출발: 인천(ICN) - 10:30 AM'),
                  Text('도착: 나리타(NRT) - 1:15 PM'),
                  SizedBox(height: 8),
                  Text('가격: ₩350,000', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
