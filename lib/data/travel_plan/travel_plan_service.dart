import 'package:dio/dio.dart';
import 'travel_plan_model.dart';

class TravelPlanService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080', // Android emulator 기준
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
    contentType: 'application/json',
  ));

  Future<void> saveTravelPlan(TravelPlanRequest request, String accessToken) async {
    try {
      final response = await _dio.post(
        '/api/travel-plans',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ 여행 계획 저장 성공");
      } else {
        print("❌ 저장 실패: ${response.data}");
      }
    } catch (e) {
      print("🚨 저장 중 오류 발생: $e");
    }
  }
}
