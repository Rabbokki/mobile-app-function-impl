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
    required String accessToken,
  }) async {
    try {
      final data = {
        'origin': flight.departureAirport,
        'destination': flight.arrivalAirport,
        'departureDate': flight.departureTime.substring(0, 10),
        'returnDate': flight.returnDepartureTime?.substring(0, 10) ?? '',
        'realTime': true,
      };

      final response = await _dio.post(
        '/api/flights/save',
        queryParameters: {
          'travelPlanId': travelPlanId,
        },
        data: data,
        options: Options(
          headers: {
            'Access_Token': accessToken,
          },
        ),
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


  Future<void> bookFlight({
    required FlightInfo flight,
    required int passengerCount,
    required String accessToken,
  }) async {
    final body = {
      "flightId": flight.id,
      "carrier": flight.carrier,
      "carrierCode": flight.carrierCode,
      "flightNumber": flight.flightNumber,
      "departureAirport": flight.departureAirport,
      "arrivalAirport": flight.arrivalAirport,
      "departureTime": flight.departureTime,
      "arrivalTime": flight.arrivalTime,
      "returnDepartureAirport": flight.returnDepartureAirport,
      "returnArrivalAirport": flight.returnArrivalAirport,
      "returnDepartureTime": flight.returnDepartureTime,
      "returnArrivalTime": flight.returnArrivalTime,
      "passengerCount": passengerCount,
      "selectedSeats": List.generate(passengerCount, (i) => "A${i + 1}"),
      "totalPrice": double.parse(flight.price) * passengerCount,
      "passengers": [],
      "contact": {"email": "test@example.com", "phone": "010-0000-0000"}
    };

    final response = await _dio.post(
      "/api/flights/book",
      data: body,
      options: Options(
        headers: {"Access_Token": accessToken},
      ),
    );

    if (response.statusCode == 200 && response.data["success"] == true) {
      print("✅ 예약 완료!");
    } else {
      print("❌ 예약 실패: ${response.data}");
      throw Exception("예약 실패");
    }
  }

}

