import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightDetailScreen extends StatelessWidget {
  const FlightDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> flight =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int price = flight['price'] is String
        ? int.tryParse(flight['price']) ?? 0
        : flight['price'];
    final int passengerCount = flight['passengerCount'] ?? 1;

    return Scaffold(
      appBar: AppBar(title: const Text('항공편 상세 정보')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${flight['airline']} (${flight['flightNumber']})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('출발지: ${flight['departureAirport']}'),
            Text('도착지: ${flight['arrivalAirport']}'),
            Text('출발 시간: ${flight['departureTime']}'),
            Text('도착 시간: ${flight['arrivalTime']}'),
            const Divider(height: 32),
            Text('👥 탑승객 수: $passengerCount명'),
            Text('💰 총 가격: ${NumberFormat('#,###').format(price * passengerCount)} ${flight['currency']}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/seat-selection',
                    arguments: flight,
                  );
                },
                child: const Text('다음: 좌석 선택'),
              ),
            )
          ],
        ),
      ),
    );
  }
}