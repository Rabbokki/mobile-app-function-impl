import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<String> _savedPlaceIds = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchPlaceDetail();
    _loadSavedPlaceIds();
  }

  Future<void> _loadSavedPlaceIds() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPlaceIds = prefs.getStringList('savedPlaceIds') ?? [];
    });
  }

  bool _isAlreadySaved(String placeId) {
    return _savedPlaceIds.contains(placeId);
  }

  Future<void> _fetchPlaceDetail() async {
    final url = 'http://10.0.2.2:8080/api/places/detail?placeId=${widget.place.placeId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        detail = data;
      });
    } else {
      print('❌ Failed to fetch details');
    }
  }

  Future<void> _savePlace() async {
    if (_isAlreadySaved(widget.place.placeId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 저장된 장소입니다.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/saved-places'),
      headers: {
        'Access_Token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'placeId': widget.place.placeId,
        'name': widget.place.name,
        'address': detail?['formatted_address'] ?? '',
        'city': widget.place.city,
        'category': widget.place.category,
      }),
    );

    if (response.statusCode == 200) {
      _savedPlaceIds.add(widget.place.placeId);
      prefs.setStringList('savedPlaceIds', _savedPlaceIds);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📌 저장 완료!')),
      );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 저장된 장소입니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ 저장 실패: ${response.statusCode}')),
      );
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('❌ Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
        backgroundColor: PlaceDetailScreen.travelingPurple,
      ),
      body: Column(
        children: [
          Image.network(
            widget.place.image,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.place.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${widget.place.rating} (${widget.place.reviewCount})'),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(widget.place.category)),
                    Chip(label: Text(widget.place.city)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(detail?['formatted_address'] ?? '주소 없음'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 8),
                    Text(detail?['formatted_phone_number'] ?? '전화번호 없음'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Expanded(
                      child: detail?['opening_hours']?['weekday_text'] != null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.from(
                          (detail!['opening_hours']['weekday_text'] as List)
                              .map((line) => Text(line)),
                        ),
                      )
                          : const Text('운영 시간 정보 없음'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (detail?['website'] != null && detail!['website'].toString().isNotEmpty)
                  GestureDetector(
                    onTap: () => _launchURL(detail!['website']),
                    child: Row(
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(width: 8),
                        Text(
                          detail!['website'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PlaceDetailScreen.travelingPurple,
                  ),
                  onPressed: _savePlace,
                  icon: const Icon(Icons.favorite_border),
                  label: const Text("저장하기"),
                ),
              ],
            ),
          ),
          const Divider(),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    detail?['editorial_summary']?['overview'] ?? '소개 정보 없음',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Center(child: Text('사진')),
                const Center(child: Text('리뷰')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
