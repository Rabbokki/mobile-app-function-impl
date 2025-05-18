import 'package:flutter/material.dart';

class Step2AttractionSelection extends StatelessWidget {
  const Step2AttractionSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장소 선택'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '오사카에서 방문하고 싶은 장소를 선택해주세요.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListView(
                      children: [
                        _PlaceItem(name: '도톤보리', rating: 4.7),
                        _PlaceItem(name: '오사카 성', rating: 4.4),
                        _PlaceItem(name: '유니버설 스튜디오', rating: 4.5),
                        _PlaceItem(name: '오렌지 공중정원', rating: 4.0),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey[300],
                      child: const Center(child: Text('🗺️ 지도 위치 영역 (추후 Google Map 연결)')),
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
                    Navigator.pushNamed(context, '/step3');
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

class _PlaceItem extends StatelessWidget {
  final String name;
  final double rating;

  const _PlaceItem({required this.name, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          color: Colors.grey[400],
          child: const Icon(Icons.photo, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text('⭐ $rating'),
        trailing: TextButton(
          onPressed: () {},
          child: const Text('선택하기'),
        ),
      ),
    );
  }
}
