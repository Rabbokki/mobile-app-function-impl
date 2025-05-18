import 'package:flutter/material.dart';

class MakeTripScreen extends StatelessWidget {
  const MakeTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 만들기'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('여행 도시', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: '도쿄', child: Text('도쿄')),
                DropdownMenuItem(value: '오사카', child: Text('오사카')),
                DropdownMenuItem(value: '파리', child: Text('파리')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('여행 날짜', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // 달력 선택 기능은 나중에 추가 가능
              },
              child: const Text('출발일 ~ 도착일 선택'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 다음 스텝 이동 예정
                },
                child: const Text('다음 단계로'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
