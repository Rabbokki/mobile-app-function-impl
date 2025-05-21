import 'package:flutter/material.dart';

class Step2AttractionSelection extends StatefulWidget {
  final int tripDays;
  const Step2AttractionSelection({super.key, required this.tripDays});

  @override
  State<Step2AttractionSelection> createState() => _Step2AttractionSelectionState();
}

class _Step2AttractionSelectionState extends State<Step2AttractionSelection> {
  static const Color travelingPurple = Color(0xFFA78BFA);
  int selectedDayIndex = 0;
  String? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('장소 선택'),
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
              '오사카에서 방문하고 싶은 장소를 선택해주세요.',
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
              child: ListView(
                children: [
                  _PlaceItem(
                    name: '도톤보리',
                    rating: 4.7,
                    onTap: () => setState(() => selectedPlace = '도톤보리'),
                  ),
                  _PlaceItem(
                    name: '오사카 성',
                    rating: 4.4,
                    onTap: () => setState(() => selectedPlace = '오사카 성'),
                  ),
                  _PlaceItem(
                    name: '유니버설 스튜디오',
                    rating: 4.5,
                    onTap: () => setState(() => selectedPlace = '유니버설 스튜디오'),
                  ),
                  _PlaceItem(
                    name: '오렌지 공중정원',
                    rating: 4.0,
                    onTap: () => setState(() => selectedPlace = '오렌지 공중정원'),
                  ),
                ],
              ),
            ),

            if (selectedPlace != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('🗺️ $selectedPlace 위치 지도 미리보기 (추후 Google Map 연결)'),
              ),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: travelingPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/step3', arguments: widget.tripDays);
                  },
                  child: const Text('다음 단계로'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PlaceItem extends StatelessWidget {
  final String name;
  final double rating;
  final VoidCallback onTap;

  const _PlaceItem({required this.name, required this.rating, required this.onTap});

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: travelingPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.photo, color: Colors.white),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('⭐ $rating'),
          trailing: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(foregroundColor: travelingPurple),
            child: const Text('선택하기'),
          ),
        ),
      ),
    );
  }
}
