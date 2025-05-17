import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('항공권 검색'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("출발지", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "예: 서울",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("도착지", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "예: 도쿄",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("출발일자", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // 달력 선택 기능은 나중에 추가해도 돼요
              },
              child: const Text("날짜 선택"),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/flight/result');
                },
                child: const Text("항공권 검색"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
