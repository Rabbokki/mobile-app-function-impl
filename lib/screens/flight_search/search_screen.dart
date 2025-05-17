import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('항공권 검색')),
      body: Center(
        child: Text('여기는 항공권 검색 화면'),
      ),
    );
  }
}
