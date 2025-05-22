import 'package:flutter/material.dart';

class MakeTripScreen extends StatelessWidget {
  const MakeTripScreen({super.key});

  static const List<Map<String, String>> destinations = [
    {
      'city': 'OSAKA',
      'country': '일본 오사카',
      'route': '/step1',
      'image': 'assets/images/osaka.jpg',
    },
    {
      'city': 'TOKYO',
      'country': '일본 도쿄',
      'route': '/step1',
      'image': 'assets/images/tokyo.png',
    },
    {
      'city': 'FUKUOKA',
      'country': '일본 후쿠오카',
      'route': '/step1',
      'image': 'assets/images/fukuoka.png',
    },
    {
      'city': 'PARIS',
      'country': '프랑스 파리',
      'route': '/step1',
      'image': 'assets/images/paris.png',
    },
    {
      'city': 'ROME',
      'country': '이탈리아 로마',
      'route': '/step1',
      'image': 'assets/images/rome.png',
    },
    {
      'city': 'VENICE',
      'country': '이탈리아 베니스',
      'route': '/step1',
      'image': 'assets/images/venice.png',
    },
    {
      'city': 'BANGKOK',
      'country': '태국 방콕',
      'route': '/step1',
      'image': 'assets/images/bangkok.png',
    },
    {
      'city': 'SINGAPORE',
      'country': '싱가포르',
      'route': '/step1',
      'image': 'assets/images/singapore.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color travelingPurple = Color(0xFFA78BFA);

    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 만들기'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [travelingPurple.withOpacity(0.9), travelingPurple.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: travelingPurple.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/step1');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          '나의 여행 만들기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFB74D), Color(0xFFFF8A65)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ai_itinerary');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'AI 추천 일정 만들기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  final city = destinations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          city['route']!,
                          arguments: {'city': city['city']} //
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            city['image']!,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  city['city']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  city['country']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
