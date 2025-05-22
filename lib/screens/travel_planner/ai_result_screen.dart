import 'package:flutter/material.dart';

class AiResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const AiResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI 추천 일정")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(result.toString()), // 나중에 ListView로 예쁘게
      ),
    );
  }
}
