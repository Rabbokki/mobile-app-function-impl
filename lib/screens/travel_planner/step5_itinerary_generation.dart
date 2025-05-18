import 'package:flutter/material.dart';

class Step5ItineraryGeneration extends StatelessWidget {
  const Step5ItineraryGeneration({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> itinerary = {
      '1일차': ['도톤보리 방문', '호텔 체크인'],
      '2일차': ['오사카성 관광', '유니버설 스튜디오'],
      '3일차': ['쇼핑 및 귀국'],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 일정 요약'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '선택한 일정이 아래와 같이 정리되었어요!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: itinerary.entries.map((entry) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...entry.value.map((place) => Text('- $place')),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('일정이 저장되었습니다!')),
                  );
                },
                child: const Text('여행 일정 저장하기'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
