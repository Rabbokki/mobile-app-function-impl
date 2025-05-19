import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDetailScreen extends StatelessWidget {
  final String city;
  final String startDate;
  final String endDate;

  const TripDetailScreen({
    super.key,
    required this.city,
    required this.startDate,
    required this.endDate,
  });

  Map<String, List<Map<String, String>>> getDummyItinerary() {
    return {
      '1일차': [
        {'time': '10:00', 'activity': '도톤보리 방문'},
        {'time': '13:00', 'activity': '오사카성 관광'},
        {'time': '18:00', 'activity': '유니버설 스튜디오'},
      ],
      '2일차': [
        {'time': '11:00', 'activity': '신사이바시 쇼핑'},
        {'time': '15:00', 'activity': '고베 포트타워'},
      ],
    };
  }

  void openInGoogleMaps(String place) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place)}');
    print('👉 열려고 하는 URL: $url');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('❌ 구글 지도 실행 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = getDummyItinerary();

    return Scaffold(
      appBar: AppBar(
        title: Text('$city 여행 일정'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('도시: $city', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('기간: $startDate ~ $endDate', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text('🗓️ 여행 일정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: itinerary.entries.map((entry) {
                  final day = entry.key;
                  final activities = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                      const SizedBox(height: 6),
                      ...activities.map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        title: Text(
                          '${item['time']} : ${item['activity']}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          openInGoogleMaps(item['activity']!);
                        },
                      )),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
