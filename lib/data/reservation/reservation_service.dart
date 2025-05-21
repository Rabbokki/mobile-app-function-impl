import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
    ),
  );

  Future<void> saveReservation({
    required String accessToken,
    required Map<String, dynamic> flightInfo,
  }) async {
    try {
      final response = await _dio.post(
        '/api/flights/book',
        data: flightInfo,
        options: Options(
          headers: {'Access_Token': accessToken}, // ✅ 헤더 키 변경
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('✅ 예약 저장 성공!');
      } else {
        print('예약 저장 실패: ${response.data}');
      }
    } catch (e) {
      print('예약 저장 중 오류 발생: $e');
    }
  }

  Future<List<dynamic>> fetchMyReservations({required String accessToken}) async {
    try {
      final response = await _dio.get(
        '/api/flights/my-bookings',
        options: Options(
          headers: {'Access_Token': accessToken}, // ✅ 헤더 키 변경
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception('예약 목록 조회 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('예약 목록 조회 중 오류 발생: $e');
    }
  }
}

