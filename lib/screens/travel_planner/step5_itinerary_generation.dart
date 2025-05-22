import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';

class Step5ItineraryGeneration extends StatelessWidget {
  final String city;
  const Step5ItineraryGeneration({super.key, required this.city});

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final plan = context.read<TravelPlanProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('$city 일정 요약'),
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
                children: plan.dailyPlaces.entries.map((entry) {
                  final day = entry.key + 1;
                  final places = entry.value;
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
                            '$day일차',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...places.map((place) => Padding(
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
                  // 임시로 마이페이지 이동만 처리
                  Navigator.pushNamed(
                    context,
                    '/mypage',
                    arguments: {
                      'newTrip': {
                        'city': city,
                        'startDate': plan.startDate,
                        'endDate': plan.endDate,
                        'itinerary': plan.dailyPlaces.map((key, value) => MapEntry('${key + 1}일차', value)),
                        'image': _getCityImage(city),
                      }
                    },
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

  String _getCityImage(String city) {
    switch (city.toUpperCase()) {
      case 'OSAKA':
        return 'assets/images/osaka.jpg';
      case 'TOKYO':
        return 'assets/images/tokyo.png';
      case 'PARIS':
        return 'assets/images/paris.png';
      case 'ROME':
        return 'assets/images/rome.png';
      case 'VENICE':
        return 'assets/images/venice.png';
      case 'FUKUOKA':
        return 'assets/images/fukuoka.png';
      case 'BANGKOK':
        return 'assets/images/bangkok.png';
      case 'SINGAPORE':
        return 'assets/images/singapore.png';
      default:
        return 'assets/images/default_city.jpg';
    }
  }
}
