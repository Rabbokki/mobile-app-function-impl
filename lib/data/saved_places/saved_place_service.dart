import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'saved_place_model.dart'; // 여기에 SavedPlace 클래스 정의되어 있어야 함

Future<List<SavedPlace>> fetchSavedPlaces() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    throw Exception('Access token is missing.');
  }

  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/places/saved'),
    headers: {
      'Content-Type': 'application/json',
      'Access_Token': accessToken,
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
    return jsonList.map((item) => SavedPlace.fromJson(item)).toList();
  } else {
    throw Exception('저장된 장소 불러오기 실패: ${response.statusCode}');
  }
}
