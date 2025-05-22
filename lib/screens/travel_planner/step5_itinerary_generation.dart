import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';

class Step5ItineraryGeneration extends StatelessWidget {
  final String city;
  const Step5ItineraryGeneration({super.key, required this.city});

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final plan = context.watch<TravelPlanProvider>();

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
                children: [
                  ...plan.dailyPlaces.entries.map((entry) {
                    final day = entry.key;
                    final places = entry.value;
                    final hotel = plan.dailyHotels[day];

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.purple[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${day + 1}일차',
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
                            if (hotel != null) ...[
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text('🏨 숙소: $hotel'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  if (plan.transportation.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🚗 교통편: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(plan.transportation),
                          ),
                        ],
                      ),
                    ),
                ],
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
                  Navigator.popAndPushNamed(
                    context,
                    '/mypage',
                    arguments: {
                      'newTrip': {
                        'city': city,
                        'startDate': plan.startDate,
                        'endDate': plan.endDate,
                        'itinerary': plan.dailyPlaces.map((key, value) => MapEntry('${key + 1}일차', value)),
                        'hotels': plan.dailyHotels.map((key, value) => MapEntry('${key + 1}일차', value)),
                        'transportation': plan.transportation,
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
