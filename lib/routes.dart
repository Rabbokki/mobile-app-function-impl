import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/flight_search/search_screen.dart';
import 'screens/travel_planner/make_trip_screen.dart';
import 'screens/recommended_places/recommended_places_screen.dart';
import 'screens/community/community_home.dart';
import 'screens/mypage/mypage_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/flight': (context) => const SearchScreen(),
  '/make_trip': (context) => const MakeTripScreen(),
  '/recommended': (context) => const RecommendedPlacesScreen(),
  '/community': (context) => const CommunityHomeScreen(),
  '/mypage': (context) => const MyPageScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
};
