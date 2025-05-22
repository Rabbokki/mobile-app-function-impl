import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/travel_plan_provider.dart';

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

  List<Map<String, String>> _getPlacesByCity(String city) {
    switch (city.toUpperCase()) {
      case 'TOKYO':
        return [
          {'name': '도쿄 타워', 'image': 'assets/images/tokyo-night-lights.png'},
          {'name': '시부야 스크램블', 'image': 'assets/images/shibuya-intersection-bustle.png'},
        ];
      case 'PARIS':
        return [
          {'name': '에펠탑', 'image': 'assets/images/eiffel_tower.png'},
          {'name': '루브르 박물관', 'image': 'assets/images/louvre.jpg'},
          {'name': '샹젤리제 거리', 'image': 'assets/images/champs.jpg'},
          {'name': '몽마르뜨 언덕', 'image': 'assets/images/montmartre.jpg'},
        ];
      default:
        return [
          {'name': '도톤보리', 'image': 'assets/images/dotonbori.png'},
          {'name': '오사카 성', 'image': 'assets/images/osaka-castle.png'},
          {'name': '유니버설 스튜디오', 'image': 'assets/images/universal-studios.png'},
        ];
    }
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
