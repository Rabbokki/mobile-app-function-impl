import 'package:flutter/material.dart';

class CommunityHomeScreen extends StatelessWidget {
  const CommunityHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> posts = [
      {
        'title': '오사카 맛집 추천해주세요!',
        'author': '여행초보',
        'date': '2024-05-01'
      },
      {
        'title': '유럽 여행 짐 싸는 꿀팁 공유',
        'author': '지구정복자',
        'date': '2024-05-03'
      },
      {
        'title': '일본 교통패스 종류 헷갈려요ㅠㅠ',
        'author': '미나짱',
        'date': '2024-05-05'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(post['title'] ?? ''),
              subtitle: Text('${post['author']} · ${post['date']}'),
              onTap: () {
                // 상세 페이지 이동 (추후 구현 가능)
              },
            ),
          );
        },
      ),
    );
  }
}
