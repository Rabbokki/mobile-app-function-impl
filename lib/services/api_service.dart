import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/saved_places/saved_place_model.dart';

Future<List<SavedPlace>> fetchSavedPlaces() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  if (token == null) {
    throw Exception('로그인이 필요합니다.');
  }

  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/saved-places'),
    headers: {
      'Access_Token': token,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => SavedPlace.fromJson(json)).toList();
  } else {
    throw Exception('저장된 장소를 불러오는데 실패했습니다.');
  }
}
