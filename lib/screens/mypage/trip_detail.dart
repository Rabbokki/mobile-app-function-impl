import 'package:flutter/material.dart';

class TripDetailScreen extends StatelessWidget {
  final String city;
  final String startDate;
  final String endDate;
  final Map<String, dynamic>? itinerary; // 일정 데이터
  final Map<String, dynamic>? hotels; // 숙소 정보
  final String? transportation; // 교통편

  const TripDetailScreen({
    super.key,
    required this.city,
    required this.startDate,
    required this.endDate,
    this.itinerary,
    this.hotels,
    this.transportation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$city 일정'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              '$city 여행',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$startDate ~ $endDate',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              '📌 상세 일정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (itinerary != null)
              ...itinerary!.entries.map((entry) {
                final day = entry.key;
                final activities = List<String>.from(entry.value);
                final hotelInfo = hotels != null ? hotels![day] : null;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ...activities.map((activity) => Text('- $activity')).toList(),
                        if (hotelInfo != null) ...[
                          const SizedBox(height: 6),
                          Text('🏨 숙소: $hotelInfo'),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList()
            else
              const Text('저장된 일정이 없습니다.'),

            if (transportation != null && transportation!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                '🚗 교통편',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(transportation!),
            ],
          ],
        ),
      ),
    );
  }
}
