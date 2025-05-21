import 'package:dio/dio.dart';

class UserService {
  final Dio _dio;
  final String accessToken;

  UserService({required this.accessToken})
      : _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    contentType: 'application/json',
    headers: {'Access_Token': accessToken}, // 토큰 기본 헤더 설정
  ));

  // 내 정보 조회 (토큰 인증으로 현재 사용자 정보 조회)
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('/api/accounts/mypage');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('사용자 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('사용자 정보 조회 중 오류 발생: $e');
    }
  }

  // 내 정보 업데이트
  Future<void> updateUserProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _dio.put(
        '/api/accounts/mypage',
        data: updateData,
      );
      if (response.statusCode == 200) {
        print('✅ 사용자 정보 업데이트 성공');
      } else {
        throw Exception('사용자 정보 업데이트 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('사용자 정보 업데이트 중 오류 발생: $e');
    }
  }
}
