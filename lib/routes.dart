import 'package:flutter/material.dart';
import 'package:mobile_app_function_impl/screens/home_screen.dart';
import 'package:mobile_app_function_impl/screens/flight_search/search_screen.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/make_trip_screen.dart';
import 'package:mobile_app_function_impl/screens/recommended_places/recommended_places_screen.dart';
import 'package:mobile_app_function_impl/screens/community/community_home.dart';
import 'package:mobile_app_function_impl/screens/mypage/mypage_screen.dart';
import 'package:mobile_app_function_impl/screens/mypage/trip_detail.dart';
import 'package:mobile_app_function_impl/screens/auth/login_screen.dart';
import 'package:mobile_app_function_impl/screens/auth/signup_screen.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/manual_itinerary_screen.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/ai_itinerary_screen.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/step1_date_selection.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/step2_attraction_selection.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/step3_accommodation_selection.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/step4_transportation_selection.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/step5_itinerary_generation.dart';

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
  '/step4': (context) => const Step4TransportationSelection(),
  '/step5': (context) => const Step5ItineraryGeneration(),
};
