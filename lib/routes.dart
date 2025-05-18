import 'package:flutter/material.dart';

// 화면 import
import 'screens/home_screen.dart';
import 'screens/flight_search/search_screen.dart';
import 'screens/travel_planner/make_trip_screen.dart';
import 'screens/recommended_places/recommended_places_screen.dart';
import 'screens/community/community_home.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/flight': (context) => const SearchScreen(),
  '/make_trip': (context) => const MakeTripScreen(),
  '/recommended': (context) => const RecommendedPlacesScreen(),
  '/community': (context) => const CommunityHomeScreen(),
};
