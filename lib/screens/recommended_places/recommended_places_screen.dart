import 'package:flutter/material.dart';

class RecommendedPlacesScreen extends StatefulWidget {
  const RecommendedPlacesScreen({super.key});

  @override
  State<RecommendedPlacesScreen> createState() => _RecommendedPlacesScreenState();
}

class _RecommendedPlacesScreenState extends State<RecommendedPlacesScreen> {
  static const Color travelingPurple = Color(0xFFA78BFA);

  final List<String> filters = ['전체', '도쿄', '오사카', '후쿠오카', '로마', '파리'];
  String selectedFilter = '전체';

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> dummyPlaces = [
    {
      'name': '보르게세 공원',
      'category': '관광지',
      'city': '로마',
      'image': 'https://picsum.photos/200/150?random=1',
      'rating': 4.6,
    },
    {
      'name': '에펠탑',
      'category': '관광지',
      'city': '파리',
      'image': 'https://picsum.photos/200/150?random=2',
      'rating': 4.8,
    },
    {
      'name': '도톤보리',
      'category': '관광지',
      'city': '오사카',
      'image': 'https://picsum.photos/200/150?random=3',
      'rating': 4.5,
    },
    {
      'name': '신주쿠 교엔',
      'category': '공원',
      'city': '도쿄',
      'image': 'https://picsum.photos/200/150?random=4',
      'rating': 4.4,
    },
  ];

  List<Map<String, dynamic>> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    filteredPlaces = dummyPlaces;
  }

  void _filterPlaces() {
    final keyword = searchController.text.trim().toLowerCase();

    setState(() {
      filteredPlaces = dummyPlaces.where((place) {
        final name = place['name'].toString().toLowerCase();
        final city = place['city'].toString();

        final matchesKeyword = keyword.isEmpty ||
            name.contains(keyword) ||
            city.toLowerCase().contains(keyword);
        final matchesCity = selectedFilter == '전체' || city == selectedFilter;

        return matchesKeyword && matchesCity;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('추천 명소'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (_) => _filterPlaces(),
              decoration: InputDecoration(
                hintText: '명소 이름, 도시 등을 검색하세요',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                    _filterPlaces();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? travelingPurple : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: filteredPlaces.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final place = filteredPlaces[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            place['image'] ?? '',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place['name'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(place['city'] ?? '', style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text('${place['rating']}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/place_detail',
                                      arguments: {
                                        'name': place['name'],
                                        'city': place['city'],
                                        'imageUrl': place['image'],
                                        'rating': place['rating'],
                                      },
                                    );
                                  },
                                  child: const Text('상세보기', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
