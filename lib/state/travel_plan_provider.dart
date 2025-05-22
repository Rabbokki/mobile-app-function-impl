import 'package:flutter/material.dart';

class TravelPlanProvider with ChangeNotifier {
  String startDate = '';
  String endDate = '';
  String city = '';
  Map<int, List<String>> dailyPlaces = {}; // 일차별 장소 목록
  Map<int, String> dailyHotels = {};        // 일차별 숙소
  String transportation = '';

  void setDates(String start, String end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  void setCity(String selectedCity) {
    city = selectedCity;
    notifyListeners();
  }

  void togglePlace(int dayIndex, String place) {
    final list = dailyPlaces[dayIndex] ?? [];
    if (list.contains(place)) {
      list.remove(place);
    } else {
      list.add(place);
    }
    dailyPlaces[dayIndex] = list;
    notifyListeners();
  }

  void setPlacesByDay(Map<int, List<String>> placesByDay) {
    dailyPlaces = placesByDay;
    notifyListeners();
  }

  void setHotelsByDay(Map<int, String> hotelsByDay) {
    dailyHotels = Map.from(hotelsByDay);
    notifyListeners();
  }

  void setHotel(int dayIndex, String hotelName) {
    dailyHotels[dayIndex] = hotelName;
    notifyListeners();
  }

  void applyHotelToAll(String hotelName, int totalDays) {
    for (int i = 0; i < totalDays; i++) {
      dailyHotels[i] = hotelName;
    }
    notifyListeners();
  }

  void setTransportation(String method) {
    transportation = method;
    notifyListeners();
  }

  Map<String, dynamic> toTravelPlanRequest() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'city': city,
      'places': dailyPlaces,
      'hotels': dailyHotels,
      'transportation': transportation,
    };
  }

  void reset() {
    startDate = '';
    endDate = '';
    city = '';
    dailyPlaces.clear();
    dailyHotels.clear();
    transportation = '';
    notifyListeners();
  }
}
