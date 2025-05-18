import 'package:flutter/material.dart';

class RecommendedPlacesScreen extends StatelessWidget {
  const RecommendedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> recommendedPlaces = [
      {
        'name': '도톤보리',
        'city': '오사카',
        'image': 'assets/images/dotonbori.png',
      },
      {
        'name': '에펠탑',
        'city': '파리',
        'image': 'assets/images/eiffel_tower.png',
      },
      {
        'name': '마리나 베이 샌즈',
        'city': '싱가포르',
        'image': 'assets/images/marina_bay.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 명소'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: recommendedPlaces.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final place = recommendedPlaces[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Image.asset(
                place['image'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(place['name'] ?? ''),
              subtitle: Text(place['city'] ?? ''),
              onTap: () {
                // 상세 페이지 이동 예정
              },
            ),
          );
        },
      ),
    );
  }
}
