import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/recommended_places/recommended_place_model.dart';

class SavedPlaceService {
  Future<bool> savePlace(RecommendedPlace place) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('❌ accessToken 없음: 로그인 필요');
      return false;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/saved-places'),
      headers: {
        'Content-Type': 'application/json',
        'Access_Token': accessToken, // 백엔드가 요구하는 헤더 키
      },
      body: jsonEncode({
        'placeId': place.placeId,
        'name': place.name,
        'city': place.city,
        'country': '일본', // 나라 데이터 나중에 자동 처리해도 OK
        'image': place.image,
        'type': place.category,
      }),
    );

    print('🔁 저장 요청 결과: ${response.statusCode}');
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
