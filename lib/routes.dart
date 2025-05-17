import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/flight_search/search_screen.dart';
import 'screens/recommended_places.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/flight': (context) => const SearchScreen(),
  '/recommended': (context) => const RecommendedPlacesScreen(),
};
