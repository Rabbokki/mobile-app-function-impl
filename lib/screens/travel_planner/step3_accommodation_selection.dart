import 'package:flutter/material.dart';

class Step3AccommodationSelection extends StatefulWidget {
  final int tripDays;
  const Step3AccommodationSelection({super.key, required this.tripDays});

  @override
  State<Step3AccommodationSelection> createState() => _Step3AccommodationSelectionState();
}

class _Step3AccommodationSelectionState extends State<Step3AccommodationSelection> {
  static const Color travelingPurple = Color(0xFFA78BFA);

  int selectedDayIndex = 0;
  String? selectedHotelName;

  final List<Map<String, String>> hotels = [
    {'name': '오사카 호텔 1', 'location': '도톤보리 근처', 'price': '₩120,000/박'},
    {'name': '오사카 호텔 2', 'location': '오사카성 주변', 'price': '₩100,000/박'},
    {'name': '오사카 호텔 3', 'location': '유니버설 스튜디오 근처', 'price': '₩140,000/박'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('숙소 선택'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '원하는 숙소를 선택하세요.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: List.generate(widget.tripDays, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${index + 1}일차'),
                    selected: selectedDayIndex == index,
                    selectedColor: travelingPurple,
                    onSelected: (_) {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    labelStyle: TextStyle(
                      color: selectedDayIndex == index ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        hotel['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(hotel['location']!),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(hotel['price']!, style: const TextStyle(color: Colors.black87)),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedHotelName = hotel['name'];
                              });
                            },
                            style: TextButton.styleFrom(foregroundColor: travelingPurple),
                            child: const Text('선택'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (selectedHotelName != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('🗺️ "$selectedHotelName" 위치 지도 미리보기 (추후 Google Map 연결)'),
              ),
            ],

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/step4');
                },
                child: const Text('다음 단계로'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
