import 'package:flutter/material.dart';

class RecommendedPlacesScreen extends StatelessWidget {
  const RecommendedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('추천 명소')),
      body: Center(
        child: Text('추천 명소 목록'),
      ),
    );
  }
}
