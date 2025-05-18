import 'package:flutter/material.dart';

class Step4TransportationSelection extends StatefulWidget {
  const Step4TransportationSelection({super.key});

  @override
  State<Step4TransportationSelection> createState() => _Step4TransportationSelectionState();
}

class _Step4TransportationSelectionState extends State<Step4TransportationSelection> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('교통편 선택'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '어떤 교통편을 이용하실 예정인가요?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: selected == '대중교통' ? Colors.purple : Colors.grey[300],
                foregroundColor: selected == '대중교통' ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                setState(() {
                  selected = '대중교통';
                });
              },
              icon: const Icon(Icons.train),
              label: const Text('대중교통'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: selected == '승용차' ? Colors.purple : Colors.grey[300],
                foregroundColor: selected == '승용차' ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                setState(() {
                  selected = '승용차';
                });
              },
              icon: const Icon(Icons.directions_car),
              label: const Text('승용차'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selected != null
                    ? () {
                  Navigator.pushNamed(context, '/step5');
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
