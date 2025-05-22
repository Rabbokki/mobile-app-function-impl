import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';

class DateSelectionScreen extends StatefulWidget {
  final String city;

  const DateSelectionScreen({
    Key? key,
    required this.city,
  }) : super(key: key);

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? startDate;
  DateTime? endDate;
  static const Color travelingPurple = Color(0xFFA78BFA);

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: travelingPurple,
          colorScheme: const ColorScheme.light(primary: travelingPurple),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });

      context.read<TravelPlanProvider>().setDates(
        picked.start.toIso8601String().split('T')[0],
        picked.end.toIso8601String().split('T')[0],
      );

      final tripDays = picked.end.difference(picked.start).inDays + 1;

      Navigator.pushNamed(
        context,
        '/step2',
        arguments: {
          'tripDays': tripDays,
          'city': widget.city,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = startDate != null && endDate != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('${widget.city} 날짜 선택'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // 아이콘 컨테이너 + 중앙 보정
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Transform.translate(
                  offset: const Offset(2, 0), // 👈 약간 오른쪽으로 밀기
                  child: const Icon(
                    Icons.calendar_month,
                    size: 64,
                    color: travelingPurple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '여행 날짜를 선택하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '출발일과 도착일을 선택하면\n자동으로 다음 단계로 넘어갑니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _selectDateRange,
              style: ElevatedButton.styleFrom(
                backgroundColor: travelingPurple,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('출발일 ~ 도착일 선택'),
            ),
            const SizedBox(height: 16),
            if (canProceed)
              Text(
                '선택한 날짜: ${startDate!.toLocal().toString().split(' ')[0]} ~ ${endDate!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
