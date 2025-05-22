import 'package:dio/dio.dart';

class AiItineraryService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // 나중에 실제 주소로 변경 가능
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
    ),
  );

  Future<Map<String, dynamic>> generateItinerary({
    required String destination,
    required String preferences,
    required int budget,
    required int pace,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.post(
        '/api/generate-itinerary',
        data: {
          "destination": destination,
          "preferences": preferences,
          "budget": budget,
          "pace": pace,
          "start_date": startDate,
          "end_date": endDate,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('AI 일정 생성 실패');
      }
    } catch (e) {
      print('❌ AI 일정 요청 에러: $e');
      rethrow;
    }
  }
}
