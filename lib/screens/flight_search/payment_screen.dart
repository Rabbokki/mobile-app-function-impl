import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> flightWithPassenger;

  const PaymentScreen({super.key, required this.flightWithPassenger});

  @override
  Widget build(BuildContext context) {
    final int passengerCount = flightWithPassenger['passengerCount'] ?? 1;
    final List<String> selectedSeats = (flightWithPassenger['selectedSeats'] ?? [])?.cast<String>() ?? [];
    final int price = flightWithPassenger['price'] is String
        ? int.tryParse(flightWithPassenger['price']) ?? 0
        : flightWithPassenger['price'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${flightWithPassenger['airline']} (${flightWithPassenger['flightNumber']})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('출발지: ${flightWithPassenger['departureAirport']}'),
            Text('도착지: ${flightWithPassenger['arrivalAirport']}'),
            Text('출발 시간: ${flightWithPassenger['departureTime']}'),
            Text('도착 시간: ${flightWithPassenger['arrivalTime']}'),
            const Divider(height: 32),
            Text('탑승객 수: $passengerCount명'),
            Text('선택 좌석: ${selectedSeats.join(', ')}'),
            const SizedBox(height: 16),
            Text(
              '총 결제 금액: ${NumberFormat('#,###').format(price * passengerCount)} ${flightWithPassenger['currency']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 실제 결제 로직 구현
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('결제 완료'),
                      content: const Text('결제가 성공적으로 완료되었습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // AlertDialog 닫고
                            Navigator.pushReplacementNamed(context, '/mypage'); // 마이페이지로 이동
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('결제하기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
