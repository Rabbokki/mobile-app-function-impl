import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/flight_search/flight_info_model.dart';
import '../../../data/flight_search/flight_search_service.dart';

class ResultScreen extends StatefulWidget {
  final List<FlightInfo> flightResults;
  final int initialPassengerCount; // 추가

  const ResultScreen({
    super.key,
    required this.flightResults,
    this.initialPassengerCount = 1, // 기본값 1명
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final FlightSearchService _flightService = FlightSearchService();

  late int selectedPassengerCount; // late로 변경

  @override
  void initState() {
    super.initState();
    selectedPassengerCount = widget.initialPassengerCount; // 초기값 설정
  }

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
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        return;
      }

      print('✈️ 저장 요청 실행됨');

      await _flightService.bookFlight(
        flight: flight,
        passengerCount: selectedPassengerCount,
        accessToken: accessToken,
      );

      Navigator.pushNamed(context, '/flight_detail', arguments: {
        'airline': flight.carrier,
        'flightNumber': flight.flightNumber,
        'departureAirport': flight.departureAirport,
        'arrivalAirport': flight.arrivalAirport,
        'departureTime': flight.departureTime,
        'arrivalTime': flight.arrivalTime,
        'price': flight.price,
        'currency': flight.currency,
        'passengerCount': selectedPassengerCount,
      });
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
      body: Column(
        children: [
          // 탑승객 수 선택 드롭다운
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Text('탑승객 수:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: selectedPassengerCount,
                  onChanged: (value) {
                    setState(() {
                      selectedPassengerCount = value!;
                    });
                    print('탑승객 수 변경됨: $selectedPassengerCount');
                  },
                  items: List.generate(9, (index) => index + 1)
                      .map((num) => DropdownMenuItem(
                    value: num,
                    child: Text('$num명'),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 검색 결과 리스트
          Expanded(
            child: widget.flightResults.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다.'))
                : ListView.builder(
              itemCount: widget.flightResults.length,
              itemBuilder: (context, index) {
                final flight = widget.flightResults[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${flight.carrier} (${flight.flightNumber})',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text('출발지: ${flight.departureAirport}'),
                            Text('도착지: ${flight.arrivalAirport}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '출발시간: ${_formatDateTime(flight.departureTime)}'),
                            Text(
                                '도착시간: ${_formatDateTime(flight.arrivalTime)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '💸 가격: ${NumberFormat('#,###').format(int.parse(flight.price) * selectedPassengerCount)} ${flight.currency} (총 ${selectedPassengerCount}명)',
                        ),
                        if (flight.returnDepartureTime != null &&
                            flight.returnDepartureTime!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 24),
                              const Text('🛬 귀국 여정',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '귀국 출발: ${_formatDateTime(flight.returnDepartureTime!)}'),
                              Text(
                                  '귀국 도착: ${_formatDateTime(flight.returnArrivalTime!)}'),
                            ],
                          ),
                        const SizedBox(height: 16),
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
          ),
        ],
      ),
    );
  }
}
