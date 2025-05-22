import 'package:dio/dio.dart';

class RecommendedPlaceService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080', // 에뮬레이터용 로컬 주소
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<List<dynamic>> fetchRecommendedPlaces(String city) async {
    final response = await _dio.get('/api/places', queryParameters: {
      'city': city,
      'type': 'attraction',
    });

    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw Exception('추천 명소 불러오기 실패');
    }
  }
}
