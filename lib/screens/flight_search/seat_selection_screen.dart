import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> flight;

  const SeatSelectionScreen({super.key, required this.flight});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late int passengerCount;
  late List<String> selectedSeats;

  // 비행기 좌석 행수와 열(알파벳)
  final int rowCount = 30;
  final List<String> seatColumns = ['A', 'B', 'C', 'D', 'E'];

  // 임의로 예약 불가 좌석 지정 (예시)
  final Set<String> unavailableSeats = {
    'A3', 'B7', 'C10', 'D15', 'E20', 'A25',
  };

  late final List<String> allSeats;

  @override
  void initState() {
    super.initState();
    passengerCount = widget.flight['passengerCount'] ?? 1;
    selectedSeats = [];

    // 행과 열을 조합해 좌석 리스트 생성 (예: A1, B1, C1, ... E30)
    allSeats = [];
    for (int row = 1; row <= rowCount; row++) {
      for (final col in seatColumns) {
        allSeats.add('$col$row');
      }
    }
  }

  void _toggleSeat(String seat) {
    if (unavailableSeats.contains(seat)) return; // 예약불가 좌석은 선택 불가

    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        if (selectedSeats.length < passengerCount) {
          selectedSeats.add(seat);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('최대 $passengerCount개 좌석만 선택할 수 있어요.')),
          );
        }
      }
    });
  }

  void _goToPassengerInput() {
    if (selectedSeats.length == passengerCount) {
      Navigator.pushNamed(
        context,
        '/passenger_info',
        arguments: {
          ...widget.flight,
          'selectedSeats': selectedSeats,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좌석 $passengerCount개를 선택해주세요.')),
      );
    }
  }

  Color _getSeatColor(String seat) {
    if (unavailableSeats.contains(seat)) {
      return Colors.grey; // 예약불가 회색
    } else if (selectedSeats.contains(seat)) {
      return Colors.purple; // 선택된 좌석 보라색
    } else {
      return Colors.green[300]!; // 선택 가능 좌석 연두색
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좌석 선택'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text('좌석을 선택해주세요. (총 $passengerCount명)'),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 열 개수
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: allSeats.length,
                itemBuilder: (context, index) {
                  final seat = allSeats[index];
                  final isUnavailable = unavailableSeats.contains(seat);
                  final isSelected = selectedSeats.contains(seat);

                  return GestureDetector(
                    onTap: () => _toggleSeat(seat),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getSeatColor(seat),
                        borderRadius: BorderRadius.circular(8),
                        border: isUnavailable
                            ? Border.all(color: Colors.grey.shade700, width: 1.5)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        seat,
                        style: TextStyle(
                          color: isUnavailable
                              ? Colors.black38
                              : (isSelected ? Colors.white : Colors.black87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                selectedSeats.length == passengerCount ? _goToPassengerInput : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('다음: 탑승객 정보 입력'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
