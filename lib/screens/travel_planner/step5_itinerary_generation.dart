import 'package:flutter/material.dart';
import 'package:mobile_app_function_impl/data/saved_trips.dart';

class Step5ItineraryGeneration extends StatelessWidget {
  const Step5ItineraryGeneration({super.key});

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> itinerary = {
      '1일차': ['도톤보리 방문', '호텔 체크인'],
      '2일차': ['오사카성 관광', '유니버설 스튜디오'],
      '3일차': ['쇼핑 및 귀국'],
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('여행 일정 요약'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
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
                          ...entry.value.map((place) => Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 4),
                            child: Text('• $place'),
                          )),
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
                  backgroundColor: travelingPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final newTrip = {
                    'city': '도쿄',
                    'startDate': '2025-06-01',
                    'endDate': '2025-06-04',
                    'itinerary': itinerary,
                  };

                  savedTrips.add(newTrip);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('일정이 저장되었습니다!')),
                  );

                  Navigator.pushNamed(context, '/mypage');
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
