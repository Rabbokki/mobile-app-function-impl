import 'package:flutter/material.dart';

class MakeTripScreen extends StatelessWidget {
  const MakeTripScreen({super.key});

  final List<Map<String, String>> destinations = const [
    {
      'city': 'OSAKA',
      'country': '일본 오사카',
      'route': '/step1',
    },
    {
      'city': 'TOKYO',
      'country': '일본 도쿄',
      'route': '/step1',
    },
    {
      'city': 'FUKUOKA',
      'country': '일본 후쿠오카',
      'route': '/step1',
    },
    {
      'city': 'PARIS',
      'country': '프랑스 파리',
      'route': '/step1',
    },
    {
      'city': 'ROME',
      'country': '이탈리아 로마',
      'route': '/step1',
    },
    {
      'city': 'VENICE',
      'country': '이탈리아 베니스',
      'route': '/step1',
    },
    {
      'city': 'BANGKOK',
      'country': '태국 방콕',
      'route': '/step1',
    },
    {
      'city': 'SINGAPORE',
      'country': '싱가포르',
      'route': '/step1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 만들기'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 상단 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/manual_itinerary');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '나의 여행 만들기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ai_itinerary');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'AI 추천 일정 만들기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              '어디로 여행을 떠나시나요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: destinations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final city = destinations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, city['route']!);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        color: Colors.grey.shade300,
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    city['city']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    city['country']!,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
