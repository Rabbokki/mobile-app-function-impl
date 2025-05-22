import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';

class Step4TransportationSelection extends StatefulWidget {
  final String city;
  const Step4TransportationSelection({super.key, required this.city});

  @override
  State<Step4TransportationSelection> createState() => _Step4TransportationSelectionState();
}

class _Step4TransportationSelectionState extends State<Step4TransportationSelection> {
  static const Color travelingPurple = Color(0xFFA78BFA);
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('교통편 선택'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
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
            _buildOptionButton('대중교통', Icons.train),
            const SizedBox(height: 16),
            _buildOptionButton('승용차', Icons.directions_car),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedMethod != null
                    ? () {
                  context.read<TravelPlanProvider>().setTransportation(selectedMethod!);
                  Navigator.pushNamed(
                    context,
                    '/step5',
                    arguments: {'city': widget.city},
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('다음 단계로'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String label, IconData icon) {
    final isSelected = selectedMethod == label;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? travelingPurple : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isSelected ? 3 : 1,
      ),
      onPressed: () {
        setState(() {
          selectedMethod = label;
        });
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
