import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/flight_search/flight_info_model.dart';
import '../../../data/flight_search/flight_search_service.dart';

class ResultScreen extends StatelessWidget {
  final List<FlightInfo> flightResults;
  final FlightSearchService _flightService = FlightSearchService();

  ResultScreen({super.key, required this.flightResults});

  String _formatDateTime(String rawDateTime) {
    try {
      final dateTime = DateTime.parse(rawDateTime);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return rawDateTime;
    }
  }

  void _handleSave(BuildContext context, FlightInfo flight) async {
    try {
      await _flightService.saveFlight(
        flight: flight,
        travelPlanId: 1, // ✅ travelPlanId 고정 (테스트용)
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ 항공편이 여행 일정에 저장되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ 저장 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: flightResults.isEmpty
          ? const Center(child: Text('검색 결과가 없습니다.'))
          : ListView.builder(
        itemCount: flightResults.length,
        itemBuilder: (context, index) {
          final flight = flightResults[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 항공사 및 편명
                  Text(
                    '${flight.carrier} (${flight.flightNumber})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // 출발/도착 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('출발지: ${flight.departureAirport}'),
                      Text('도착지: ${flight.arrivalAirport}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('출발시간: ${_formatDateTime(flight.departureTime)}'),
                      Text('도착시간: ${_formatDateTime(flight.arrivalTime)}'),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 가격
                  Text('💸 가격: ${flight.price} ${flight.currency}'),

                  // 귀국 여정
                  if (flight.returnDepartureTime != null &&
                      flight.returnDepartureTime!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 24),
                        const Text('🛬 귀국 여정', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('귀국 출발: ${_formatDateTime(flight.returnDepartureTime!)}'),
                        Text('귀국 도착: ${_formatDateTime(flight.returnArrivalTime!)}'),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // ✅ 저장 버튼
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleSave(context, flight),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('선택하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
