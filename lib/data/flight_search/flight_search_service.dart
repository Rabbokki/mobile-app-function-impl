import 'package:dio/dio.dart';
import 'flight_info_model.dart';

class FlightSearchService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
    ),
  );

  Future<List<FlightInfo>> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    String returnDate = '',
    bool realTime = true,
  }) async {
    final response = await _dio.post(
      '/api/flights/search',
      data: {
        'origin': origin.toUpperCase(),
        'destination': destination.toUpperCase(),
        'departureDate': departureDate,
        'returnDate': returnDate,
        'realTime': realTime,
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> flights = response.data['flights'];
      return flights.map((json) => FlightInfo.fromJson(json)).toList();
    } else {
      throw Exception('항공권 검색 실패: ${response.data}');
    }
  }

  // ✅ 항공편 저장 기능 추가
  Future<void> saveFlight({
    required FlightInfo flight,
    required int travelPlanId,
  }) async {
    try {
      final data = {
        'origin': flight.departureAirport, // 예: ICN
        'destination': flight.arrivalAirport, // 예: NRT
        'departureDate': flight.departureTime.substring(0, 10), // "YYYY-MM-DD"
        'returnDate': flight.returnDepartureTime?.substring(0, 10) ?? '',
        'realTime': true,
      };


      final response = await _dio.post(
        '/api/flights/save',
        queryParameters: {
          'travelPlanId': travelPlanId,
        },
        data: data,
      );

      if (response.statusCode == 200) {
        print('✅ 저장 성공!');
      } else {
        throw Exception('저장 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('❌ 저장 중 오류 발생: $e');
    }
  }
}
