import 'package:flutter/material.dart';

class Step1DateSelection extends StatefulWidget {
  const Step1DateSelection({super.key});

  @override
  State<Step1DateSelection> createState() => _Step1DateSelectionState();
}

class _Step1DateSelectionState extends State<Step1DateSelection> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.purple,
            colorScheme: const ColorScheme.light(primary: Colors.purple),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceed = startDate != null && endDate != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('날짜 선택'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '여행 날짜를 선택하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectDateRange,
              child: const Text('출발일 ~ 도착일 선택'),
            ),
            const SizedBox(height: 20),
            if (startDate != null && endDate != null)
              Text(
                '선택한 날짜: ${startDate!.toLocal().toString().split(' ')[0]} ~ ${endDate!.toLocal().toString().split(' ')[0]}',
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                  Navigator.pushNamed(context, '/step2');
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text('다음 단계로'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
