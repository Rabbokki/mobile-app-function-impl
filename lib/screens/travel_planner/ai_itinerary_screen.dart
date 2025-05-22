import 'package:flutter/material.dart';
import '../../data/travel_plan/ai_itinerary_service.dart';
import 'ai_result_screen.dart';

class AiItineraryScreen extends StatefulWidget {
  final String city;

  const AiItineraryScreen({
    Key? key,
    required this.city,
  }) : super(key: key);

  @override
  State<AiItineraryScreen> createState() => _AiItineraryScreenState();
}

class _AiItineraryScreenState extends State<AiItineraryScreen> {
  double budgetLevel = 0.5;
  double paceLevel = 0.5;
  String preference = '';

  static const Color travelingPurple = Color(0xFFA78BFA);

  String get budgetLabel {
    if (budgetLevel < 0.34) return '저예산';
    if (budgetLevel < 0.67) return '중간';
    return '고예산';
  }

  String get paceLabel {
    if (paceLevel < 0.34) return '여유롭게';
    if (paceLevel < 0.67) return '균형있게';
    return '바쁘게';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('${widget.city} AI 일정 만들기'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '여행 선호도',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              onChanged: (value) => preference = value,
              decoration: const InputDecoration(
                hintText: '예: 역사 유적지를 좋아하고, 자연 경관을 즐깁니다.',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '예산 수준',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: budgetLevel,
              onChanged: (value) => setState(() => budgetLevel = value),
              divisions: 2,
              label: budgetLabel,
              activeColor: travelingPurple,
            ),
            const SizedBox(height: 24),
            const Text(
              '여행 페이스',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: paceLevel,
              onChanged: (value) => setState(() => paceLevel = value),
              divisions: 2,
              label: paceLabel,
              activeColor: travelingPurple,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (preference.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('여행 선호도를 입력해주세요.')),
                    );
                    return;
                  }

                  final service = AiItineraryService();

                  try {
                    final result = await service.generateItinerary(
                      destination: widget.city,
                      preferences: preference,
                      budget: (budgetLevel * 100).toInt(),
                      pace: (paceLevel * 100).toInt(),
                      startDate: "2025-06-01", // TODO: 실제 선택 날짜로 교체 가능
                      endDate: "2025-06-05",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AiResultScreen(result: result),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('일정 생성 실패: $e')),
                    );
                  }
                },
                child: const Text('AI 일정 생성하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
