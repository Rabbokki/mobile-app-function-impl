import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';

class Step3AccommodationSelection extends StatefulWidget {
  final int tripDays;
  final String city;

  const Step3AccommodationSelection({
    super.key,
    required this.tripDays,
    required this.city,
  });

  @override
  State<Step3AccommodationSelection> createState() => _Step3AccommodationSelectionState();
}

class _Step3AccommodationSelectionState extends State<Step3AccommodationSelection> {
  static const Color travelingPurple = Color(0xFFA78BFA);
  int selectedDayIndex = 0;
  Map<int, String> selectedHotels = {};

  final List<Map<String, dynamic>> hotels = [
    {
      'name': '호텔 오사카 베이타워',
      'location': '오사카항 근처',
      'price': 120000,
      'image': 'assets/images/hotel1.jpg',
    },
    {
      'name': '호텔 파리 라파예트',
      'location': '루브르 박물관 근처',
      'price': 200000,
      'image': 'assets/images/hotel2.jpg',
    },
    {
      'name': '도쿄 시티 호텔',
      'location': '시부야 근처',
      'price': 150000,
      'image': 'assets/images/hotel3.jpg',
    },
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '여행 일자별 숙소를 선택해주세요.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  final isSelected = selectedHotels[selectedDayIndex] == hotel['name'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          hotel['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(hotel['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hotel['location']),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedHotels[selectedDayIndex] = hotel['name'];
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: isSelected ? travelingPurple : Colors.grey,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(64, 28),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              isSelected ? '선택됨' : '선택하기',
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? travelingPurple : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text('₩${hotel['price'].toString()}/박'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedHotels.containsKey(selectedDayIndex)) {
                        final hotelName = selectedHotels[selectedDayIndex]!;
                        context.read<TravelPlanProvider>().applyHotelToAll(hotelName, widget.tripDays);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('모든 날짜에 숙소 적용 완료')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: travelingPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('모든 날짜에 적용'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TravelPlanProvider>().dailyHotels.addAll(selectedHotels);
                      Navigator.pushNamed(
                        context,
                        '/step4',
                        arguments: {'city': widget.city},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: travelingPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('다음 단계로'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
