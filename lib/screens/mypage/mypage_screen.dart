import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/reservation/reservation_service.dart';
import 'trip_detail.dart'; // 내 여행 일정 상세보기

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? myInfo;
  bool isLoading = true;

  List<dynamic> reservations = [];
  bool isLoadingReservations = true;


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

  List<Map<String, dynamic>> savedTrips = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('newTrip')) {
      final newTrip = args['newTrip'] as Map<String, dynamic>;

      if (!savedTrips.any((trip) =>
      trip['city'] == newTrip['city'] &&
          trip['startDate'] == newTrip['startDate'])) {
        setState(() {
          savedTrips.add(newTrip);
        });
      }
    }
  }



  static const Color travelingPurple = Color(0xFFA78BFA); // 회원가입 기준 색상

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchMyInfo();
    _fetchReservations();  // 항상 최신 예약 목록 가져옴
  }

  Future<void> _fetchMyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/mypage');


    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          myInfo = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (response.statusCode == 401) {
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

  // 예약 목록 불러오기
  Future<void> _fetchReservations() async {
    setState(() => isLoadingReservations = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final reservationService = ReservationService();
      final res = await reservationService.fetchMyReservations(accessToken: accessToken);
      debugPrint('예약 데이터: $res');

      setState(() {
        reservations = res;
        isLoadingReservations = false;
      });
    } catch (e) {
      setState(() => isLoadingReservations = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약 목록 불러오기 실패: $e')),
      );
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
        headers: {'Access_Token': accessToken},
      );

      if (response.statusCode == 200) {
        debugPrint('Logout successful');
        await prefs.clear(); // Clear tokens
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
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
        backgroundColor: travelingPurple,
        title: const Text('마이페이지', style: TextStyle(color: Colors.white)),
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
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '내 여행'),
            Tab(text: '내 예약'),
            Tab(text: '내 저장'),
            Tab(text: '내 리뷰'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF9FAFB),
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
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/make_trip'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add_circle_outline, size: 40, color: travelingPurple),
                          SizedBox(height: 8),
                          Text('새 여행 만들기'),
                          Text('새로운 여행 일정을 계획해보세요', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),

                ...savedTrips.map((trip) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          trip['image'] ?? 'assets/images/default_city.jpg',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.map, size: 30, color: Colors.white),
                              const SizedBox(height: 8),
                              Text(trip['city'] ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('${trip['startDate']} ~ ${trip['endDate']}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
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
                                  style: ElevatedButton.styleFrom(backgroundColor: travelingPurple),
                                  child: const Text('일정 보기', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
    if (isLoadingReservations) {
      return const Center(child: CircularProgressIndicator());
    }
    if (reservations.isEmpty) {
      return const Center(child: Text('예약 내역이 없습니다.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final res = reservations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 1.5,
          child: ListTile(
            title: Text('${res['carrier']} (${res['flightNumber']})'),
            subtitle: Text(
              '출발: ${res['departureAirport']} (${res['departureTime']})\n'
                  '도착: ${res['arrivalAirport']} (${res['arrivalTime']})\n'
                  '탑승객: ${res['passengerCount']}명\n'
                  '좌석: ${(res['selectedSeats'] as List<dynamic>).join(', ')}\n'
                  '총 금액: ₩${NumberFormat('#,###').format(res['totalPrice'])}',
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
          elevation: 1.5,
          child: ListTile(
            title: Text(item['name'] ?? ''),
            subtitle: Text('${item['location']} · ${item['type']} · 저장일: ${item['savedDate']}'),
            trailing: const Text('상세보기', style: TextStyle(color: travelingPurple)),
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
          elevation: 1.5,
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
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('수정', style: TextStyle(fontSize: 12, color: travelingPurple)),
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
    final imgUrl = myInfo?['imgUrl'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: travelingPurple.withOpacity(0.1),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: imgUrl != null && imgUrl.isNotEmpty
                ? NetworkImage(imgUrl)
                : null,
            child: imgUrl == null || imgUrl.isEmpty
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(email),
              Text(level),
            ],
          ),
        ],
      ),
    );
  }
}
