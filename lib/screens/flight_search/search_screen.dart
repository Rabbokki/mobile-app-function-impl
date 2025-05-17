import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummyFlights = [
      {
        'airline': '대한항공',
        'flightNumber': 'KE123',
        'departure': '인천(ICN)',
        'arrival': '도쿄(NRT)',
        'time': '10:30 → 13:15',
        'price': '₩350,000'
      },
      {
        'airline': '아시아나항공',
        'flightNumber': 'OZ456',
        'departure': '인천(ICN)',
        'arrival': '오사카(KIX)',
        'time': '09:10 → 11:45',
        'price': '₩290,000'
      },
      {
        'airline': '제주항공',
        'flightNumber': '7C789',
        'departure': '김포(GMP)',
        'arrival': '후쿠오카(FUK)',
        'time': '08:00 → 09:30',
        'price': '₩180,000'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('항공권 검색'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: dummyFlights.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final flight = dummyFlights[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${flight['airline']} (${flight['flightNumber']})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('출발: ${flight['departure']}'),
                  Text('도착: ${flight['arrival']}'),
                  Text('시간: ${flight['time']}'),
                  const SizedBox(height: 8),
                  Text(
                    '가격: ${flight['price']}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
