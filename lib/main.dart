import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const TravelingApp());
}

class TravelingApp extends StatelessWidget {
  const TravelingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '트래블링',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
