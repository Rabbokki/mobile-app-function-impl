import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_app_function_impl/screens/mypage/trip_detail.dart';
import 'package:mobile_app_function_impl/data/saved_trips.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? myInfo;
  bool isLoading = true;

  final List<Map<String, String>> dummyReservations = [
    {'from': 'ICN', 'to': 'NRT', 'date': '2025-06-01', 'airline': '대한항공'},
    {'from': 'ICN', 'to': 'CDG', 'date': '2025-07-10', 'airline': '에어프랑스'},
  ];

  final List<Map<String, String>> dummySavedItems = [
    {'name': '도쿄 스카이트리', 'location': '도쿄, 일본', 'type': '명소', 'savedDate': '2025.04.15'},
    {'name': '이치란 라멘', 'location': '도쿄, 일본', 'type': '맛집', 'savedDate': '2025.04.15'},
  ];

  final List<Map<String, dynamic>> dummyReviews = [
    {
      'place': '도쿄 스카이트리',
      'date': '2025.03.20',
      'rating': 4.5,
      'content': '도쿄 전경을 한눈에 볼 수 있어서 좋았습니다. 입장료가 조금 비싸지만 불만한 가치는 있어요.'
    },
    {
      'place': '이치란 라멘',
      'date': '2025.03.19',
      'rating': 5.0,
      'content': '정말 맛있었습니다! 줄이 길었지만 기다릴 만한 가치가 있었어요.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchMyInfo();
  }

  Future<void> _fetchMyInfo() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/mypage');
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken == null) {
      // No token found — maybe redirect to login
      debugPrint('No access token found, redirecting to login.');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    print('Access token: $accessToken');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          myInfo = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Failed to load profile: ${response.statusCode}');
        if (response.statusCode == 401) {
          // Token expired or invalid, logout user
          await prefs.clear();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      debugPrint('No access token found');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Access_Token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Logout successful');
        await prefs.clear(); // Clear tokens
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
      } else {
        debugPrint('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('마이페이지', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
            tooltip: '로그아웃',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.purple,
          tabs: const [
            Tab(text: '내 여행'),
            Tab(text: '내 예약'),
            Tab(text: '내 저장'),
            Tab(text: '내 리뷰'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildMyTripsTab(),
          _buildReservationTab(),
          _buildSavedTab(),
          _buildReviewTab(),
        ],
      ),
    );
  }

  Widget _buildMyTripsTab() {
    return Column(
      children: [
        _buildProfileHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/make_trip'),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle_outline, size: 40, color: Colors.blue),
                          SizedBox(height: 8),
                          Text('새 여행 만들기'),
                          Text('새로운 여행 일정을 계획해보세요', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                ...savedTrips.map((trip) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.map, size: 30, color: Colors.blue),
                      const SizedBox(height: 8),
                      Text(trip['city'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${trip['startDate']} ~ ${trip['endDate']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDetailScreen(
                                  city: trip['city'],
                                  startDate: trip['startDate'],
                                  endDate: trip['endDate'],
                                  itinerary: trip['itinerary'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                          child: const Text('일정 보기', style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildReservationTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyReservations.length,
      itemBuilder: (context, index) {
        final item = dummyReservations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('${item['from']} → ${item['to']}'),
            subtitle: Text('항공사: ${item['airline']}, 날짜: ${item['date']}'),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('상세보기'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummySavedItems.length,
      itemBuilder: (context, index) {
        final item = dummySavedItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('${item['name']}'),
            subtitle: Text('${item['location']} · ${item['type']} · 저장일: ${item['savedDate']}'),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('상세보기'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyReviews.length,
      itemBuilder: (context, index) {
        final item = dummyReviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(item['place']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('작성일: ${item['date']}'),
                const SizedBox(height: 4),
                Text(item['content']),
              ],
            ),
            trailing: SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('⭐ ${item['rating']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('수정', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    final nickname = myInfo?['nickname'] ?? '사용자';
    final email = myInfo?['email'] ?? '이메일 정보 없음';
    final level = myInfo?['level'] ?? 'Lv.1';
    final percent = myInfo?['expPercent'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(email),
              Text('여행 레벨: $level ($percent%)', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
                child: const Text('설정'),
              ),
              TextButton(onPressed: () {}, child: const Text('프로필 수정')),
            ],
          )
        ],
      ),
    );
  }
}
