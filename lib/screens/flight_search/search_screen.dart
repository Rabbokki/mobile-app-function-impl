import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String tripType = '왕복';
  String selectedDeparture = '';
  String selectedArrival = '';
  DateTime? departureDate;
  DateTime? returnDate;
  int passengers = 1;

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
        } else {
          returnDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('항공권 검색'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왕복 / 편도 / 다구간
            Row(
              children: ['왕복', '편도', '다구간'].map((type) {
                return Row(
                  children: [
                    Radio(
                      value: type,
                      groupValue: tripType,
                      onChanged: (value) {
                        setState(() {
                          tripType = value!;
                        });
                      },
                    ),
                    Text(type),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 출발지
            TextField(
              decoration: const InputDecoration(
                labelText: '출발지',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => selectedDeparture = value,
            ),
            const SizedBox(height: 12),

            // 도착지
            TextField(
              decoration: const InputDecoration(
                labelText: '도착지',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => selectedArrival = value,
            ),
            const SizedBox(height: 20),

            // 출발일 / 귀국일
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '출발일',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        departureDate == null
                            ? '날짜 선택'
                            : '${departureDate!.year}-${departureDate!.month}-${departureDate!.day}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (tripType == '왕복')
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '귀국일',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          returnDate == null
                              ? '날짜 선택'
                              : '${returnDate!.year}-${returnDate!.month}-${returnDate!.day}',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // 탑승객 수
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '탑승객 수',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                passengers = int.tryParse(value) ?? 1;
              },
            ),
            const SizedBox(height: 30),

            // 검색 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 검색 기능 연결 예정
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('검색', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
