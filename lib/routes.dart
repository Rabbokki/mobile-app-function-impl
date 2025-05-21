import 'package:flutter/material.dart';

import 'package:mobile_app_function_impl/screens/home_screen.dart';
import 'package:mobile_app_function_impl/screens/flight_search/search_screen.dart';
import 'package:mobile_app_function_impl/screens/travel_planner/make_trip_screen.dart';
import 'package:mobile_app_function_impl/screens/recommended_places/recommended_places_screen.dart';
import 'package:mobile_app_function_impl/screens/community/community_home.dart';
import 'package:mobile_app_function_impl/screens/community/write_post.dart';
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

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  late WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (BuildContext _) => const HomeScreen();
      break;
    case '/flight':
      builder = (BuildContext _) => const SearchScreen();
      break;
    case '/make_trip':
      builder = (BuildContext _) => const MakeTripScreen();
      break;
    case '/recommended':
      builder = (BuildContext _) => const RecommendedPlacesScreen();
      break;
    case '/community':
      builder = (BuildContext _) => const CommunityHomeScreen();
      break;
    case '/write_post':
      builder = (BuildContext _) => const WritePostScreen();
      break;
    case '/mypage':
      builder = (BuildContext _) => const MyPageScreen();
      break;
    case '/login':
      builder = (BuildContext _) => const LoginScreen();
      break;
    case '/signup':
      builder = (BuildContext _) => const SignupScreen();
      break;
    case '/manual_itinerary':
      builder = (BuildContext _) => const ManualItineraryScreen();
      break;
    case '/ai_itinerary':
      builder = (BuildContext _) => const AiItineraryScreen();
      break;
    case '/step1':
      builder = (BuildContext _) => const Step1DateSelection();
      break;
    case '/step2':
      builder = (BuildContext _) => const Step2AttractionSelection();
      break;
    case '/step3':
      builder = (BuildContext _) => const Step3AccommodationSelection();
      break;
    case '/step4':
      builder = (BuildContext _) => const Step4TransportationSelection();
      break;
    case '/step5':
      builder = (BuildContext _) => const Step5ItineraryGeneration();
      break;
    default:
      builder = (BuildContext _) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      );
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    settings: settings,
  );
}
