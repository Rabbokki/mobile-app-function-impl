import 'package:flutter/material.dart';

class Step1DateSelection extends StatefulWidget {
  const Step1DateSelection({super.key});

  @override
  State<Step1DateSelection> createState() => _Step1DateSelectionState();
}

class _Step1DateSelectionState extends State<Step1DateSelection> {
  DateTime? startDate;
  DateTime? endDate;
  static const Color travelingPurple = Color(0xFFA78BFA);

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: travelingPurple,
            colorScheme: const ColorScheme.light(primary: travelingPurple),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });

      // ✅ 날짜 선택 후 바로 Step2로 이동하면서 tripDays 전달
      final tripDays = picked.end.difference(picked.start).inDays + 1;
      Future.microtask(() {
        Navigator.pushNamed(
          context,
          '/step2',
          arguments: {
            'tripDays': tripDays,
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceed = startDate != null && endDate != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('날짜 선택'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(Icons.calendar_today, size: 64, color: travelingPurple),
            const SizedBox(height: 24),
            const Text(
              '여행 날짜를 선택하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '출발일과 도착일을 선택하면\n일정 생성이 시작됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _selectDateRange,
              style: ElevatedButton.styleFrom(
                backgroundColor: travelingPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  disabledBackgroundColor: Colors.grey[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('다음 단계로'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
