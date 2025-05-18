import 'package:flutter/material.dart';

class Step3AccommodationSelection extends StatelessWidget {
  const Step3AccommodationSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> hotels = [
      {
        'name': '오사카 호텔 1',
        'location': '도톤보리 근처',
        'price': '₩120,000/박'
      },
      {
        'name': '오사카 호텔 2',
        'location': '오사카성 주변',
        'price': '₩100,000/박'
      },
      {
        'name': '오사카 호텔 3',
        'location': '유니버설 스튜디오 근처',
        'price': '₩140,000/박'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('숙소 선택'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '원하는 숙소를 선택하세요.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  // 숙소 리스트
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(hotel['name']!),
                            subtitle: Text(hotel['location']!),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(hotel['price']!),
                                const SizedBox(height: 6),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('선택'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 지도 자리
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey[300],
                      child: const Center(child: Text('🗺️ 지도 영역')), // 향후 구글 맵 연결
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/step4');
                  },
                  child: const Text('다음 단계로'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
