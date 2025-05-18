import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/flight_search/search_screen.dart';
import 'screens/travel_planner/make_trip_screen.dart';
import 'screens/recommended_places/recommended_places_screen.dart';
import 'screens/community/community_home.dart';
import 'screens/mypage/mypage_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/travel_planner/manual_itinerary_screen.dart';
import 'screens/travel_planner/ai_itinerary_screen.dart';
import 'screens/travel_planner/step1_date_selection.dart';
import 'screens/travel_planner/step2_attraction_selection.dart';
import 'screens/travel_planner/step3_accommodation_selection.dart';
import 'screens/travel_planner/step5_itinerary_generation.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/flight': (context) => const SearchScreen(),
  '/make_trip': (context) => const MakeTripScreen(),
  '/recommended': (context) => const RecommendedPlacesScreen(),
  '/community': (context) => const CommunityHomeScreen(),
  '/mypage': (context) => const MyPageScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/manual_itinerary': (context) => const ManualItineraryScreen(),
  '/ai_itinerary': (context) => const AiItineraryScreen(),
  '/step1': (context) => const Step1DateSelection(),
  '/step2': (context) => const Step2AttractionSelection(),
  '/step3': (context) => const Step3AccommodationSelection(),
  '/step5': (context) => const Step5ItineraryGeneration(),

};
