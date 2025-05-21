import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'place_detail_screen.dart';
import 'recommended_place_model.dart';

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

  List<RecommendedPlace> allPlaces = [];
  List<RecommendedPlace> filteredPlaces = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() => isLoading = true);
    try {
      final result = await fetchRecommendedPlaces(selectedFilter == '전체' ? 'all' : selectedFilter);
      setState(() {
        allPlaces = result;
        filteredPlaces = result;
        isLoading = false;
      });
    } catch (e) {
      print('에러: $e');
      setState(() => isLoading = false);
    }
  }

  void _filterPlaces() {
    final keyword = searchController.text.trim().toLowerCase();
    setState(() {
      filteredPlaces = allPlaces.where((place) {
        final name = place.name.toLowerCase();
        final city = place.city.toLowerCase();

        final matchesKeyword = keyword.isEmpty || name.contains(keyword) || city.contains(keyword);
        final matchesCity = selectedFilter == '전체' || place.city == selectedFilter;

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                    _loadPlaces();
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
                            place.image,
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
                              Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(place.city, style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text('${place.rating}', style: const TextStyle(fontSize: 12)),
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
                                        'name': place.name,
                                        'city': place.city,
                                        'imageUrl': place.image,
                                        'rating': place.rating,
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

  Future<List<RecommendedPlace>> fetchRecommendedPlaces(String cityId) async {
    final uri = Uri.parse('http://10.0.2.2:8080/api/places/nearby?city=$cityId&cityId=$cityId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => RecommendedPlace.fromJson(e)).toList();
    } else {
      throw Exception('추천 명소 불러오기 실패');
    }
  }
}
