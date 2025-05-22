import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';
import '../../data/dummy_data/dummyAttractions.dart';

class Step2AttractionSelection extends StatefulWidget {
  final int tripDays;
  final String city;

  const Step2AttractionSelection({
    super.key,
    required this.tripDays,
    required this.city,
  });

  @override
  State<Step2AttractionSelection> createState() => _Step2AttractionSelectionState();
}

class _Step2AttractionSelectionState extends State<Step2AttractionSelection> {
  static const Color travelingPurple = Color(0xFFA78BFA);
  int selectedDayIndex = 0;
  Map<int, List<String>> _selectedPlacesByDay = {};

  List<Map<String, dynamic>> _getPlacesByCity(String city) {
    return dummyAttractions[city.toLowerCase()] ?? [];
  }

  void _togglePlace(String place) {
    final list = _selectedPlacesByDay[selectedDayIndex] ?? [];
    if (list.contains(place)) {
      list.remove(place);
    } else {
      list.add(place);
    }
    setState(() {
      _selectedPlacesByDay[selectedDayIndex] = list;
    });
  }

  bool _isSelected(String place) {
    return _selectedPlacesByDay[selectedDayIndex]?.contains(place) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final places = _getPlacesByCity(widget.city);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('${widget.city} 장소 선택'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.city}에서 방문하고 싶은 장소를 선택해주세요.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: places.map((place) {
                  final name = place['name']!;
                  final image = place['image']!;
                  final selected = _isSelected(name);
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                        ),
                      ),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: TextButton(
                        onPressed: () => _togglePlace(name),
                        style: TextButton.styleFrom(foregroundColor: travelingPurple),
                        child: Text(selected ? '선택됨' : '선택하기'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  context.read<TravelPlanProvider>().setPlacesByDay(_selectedPlacesByDay);

                  Navigator.pushNamed(
                    context,
                    '/step3',
                    arguments: {
                      'tripDays': widget.tripDays,
                      'city': widget.city,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
}
