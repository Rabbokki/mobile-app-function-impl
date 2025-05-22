import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> flightWithPassenger;

  const PaymentScreen({super.key, required this.flightWithPassenger});

  @override
  Widget build(BuildContext context) {
    final int passengerCount = flightWithPassenger['passengerCount'] ?? 1;
    final List<String> selectedSeats =
        (flightWithPassenger['selectedSeats'] ?? [])?.cast<String>() ?? [];
    final int price = flightWithPassenger['price'] is String
        ? int.tryParse(flightWithPassenger['price']) ?? 0
        : flightWithPassenger['price'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        centerTitle: true,
        backgroundColor: const Color(0xFFA78BFA),
        foregroundColor: Colors.white,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA78BFA), // 💜 보라색 강조
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('결제 완료'),
                      content: const Text('결제가 성공적으로 완료되었습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                            Navigator.pushReplacementNamed(context, '/mypage'); // 마이페이지로 이동
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA78BFA), // 💜 버튼 색상
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('결제하기'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
