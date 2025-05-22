import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/recommended_places/recommended_place_model.dart';

class PlaceDetailScreen extends StatefulWidget {
  final RecommendedPlace place;
  static const Color travelingPurple = Color(0xFFA78BFA);

  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? detail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchPlaceDetail();
  }

  Future<void> _fetchPlaceDetail() async {
    final uri = Uri.parse('http://10.0.2.2:8080/api/places/detail?placeId=${widget.place.placeId}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        detail = jsonDecode(utf8.decode(response.bodyBytes));
      });
    }
  }

  Future<void> _savePlace() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/saved-places'),
      headers: {
        'Content-Type': 'application/json',
        'Access_Token': accessToken,
      },
      body: jsonEncode({
        'placeId': widget.place.placeId,
        'name': widget.place.name,
        'city': widget.place.city,
        'country': '대한민국',
        'image': widget.place.image,
        'type': widget.place.category,
      }),
    );

    final success = response.statusCode == 200 || response.statusCode == 201;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? '찜 목록에 저장되었습니다!' : '저장 실패')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        backgroundColor: PlaceDetailScreen.travelingPurple,
        foregroundColor: Colors.white,
      ),
      body: detail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Image.network(
            place.image,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 + 평점
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(place.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text('${place.rating} (${place.reviewCount})'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 태그
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(place.category)),
                    Chip(label: Text(place.city)),
                  ],
                ),

                const SizedBox(height: 16),

                // 주소, 전화번호, 운영시간, 웹사이트
                Row(children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(detail?['address'] ?? '주소 없음')),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(detail?['phone'] ?? '전화번호 없음'),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(detail?['hours'] ?? '운영 시간 정보 없음')),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.public, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      final url = detail?['website'];
                      if (url != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('웹사이트: $url')),
                        );
                      }
                    },
                    child: Text(detail?['website'] ?? '웹사이트 없음',
                        style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                  ),
                ]),

                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _savePlace,
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('저장하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PlaceDetailScreen.travelingPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: '상세 정보'),
              Tab(text: '사진'),
              Tab(text: '리뷰'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(detail?['description'] ?? '소개 정보 없음'),
                ),
                const Center(child: Text('사진 준비 중')),
                const Center(child: Text('리뷰 준비 중')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
