import 'package:flutter/material.dart';

class ManualItineraryScreen extends StatelessWidget {
  const ManualItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 여행 만들기'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/step2');
          },
          child: const Text('Step2 장소 선택으로 이동'),
        ),
      ),
    );
  }
}
