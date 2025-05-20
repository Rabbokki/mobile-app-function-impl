// 게시글 상세 화면
import 'dart:io';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final imagePath = post['imagePath'];
    final tags = (post['tags'] as List<dynamic>?)?.cast<String>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // ✅ 긴 내용 스크롤 가능
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'] ?? '제목 없음',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '작성자: ${post['author'] ?? '익명'}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            if (imagePath != null && File(imagePath).existsSync()) // ✅ 이미지 존재 확인
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),
            Text(
              post['content'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            if (tags.isNotEmpty) // ✅ 태그 있을 때만 표시
              Wrap(
                spacing: 8,
                children: tags
                    .map((tag) => Chip(
                  label: Text('#$tag'),
                  backgroundColor: travelingPurple.withOpacity(0.15),
                  labelStyle: const TextStyle(color: travelingPurple),
                ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
