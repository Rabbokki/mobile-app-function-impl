import 'package:flutter/material.dart';
import 'package:mobile_app_function_impl/state/travel_plan_provider.dart';
import 'package:provider/provider.dart';
import 'routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelPlanProvider()),
        // 다른 provider도 있으면 여기 추가
      ],
      child: const TravelingApp(),
    ),
  );
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
      onGenerateRoute: onGenerateRoute,
    );
  }
}
