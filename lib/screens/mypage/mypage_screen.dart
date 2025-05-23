import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/reservation/reservation_service.dart';
import '../../data/saved_places/saved_place_model.dart';
import '../../widgets/profile_header_widget.dart';
import 'trip_detail.dart';
import '../../data/saved_places/saved_place_service.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> with SingleTickerProviderStateMixin {
  static const Color travelingPurple = Color(0xFFA78BFA);

  late TabController _tabController;
  Map<String, dynamic>? myInfo;
  bool isLoading = true;

  List<dynamic> reservations = [];
  bool isLoadingReservations = true;

  List<SavedPlace> _savedPlaces = [];
  bool _isLoadingSavedPlaces = true;

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchMyInfo();
    _fetchReservations();
    _loadTripsFromPrefs();
    _fetchSavedPlaces(); // ✅ 여기서 호출

    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('newTrip')) {
        final newTrip = args['newTrip'] as Map<String, dynamic>;
        if (!savedTrips.any((trip) =>
        trip['city'] == newTrip['city'] &&
            trip['startDate'] == newTrip['startDate'])) {
          setState(() {
            savedTrips.add(newTrip);
          });
          _saveTripsToPrefs();
        }
      }
    });
  }

  // ✅ 여기 추가된 부분
  Future<void> _fetchSavedPlaces() async {
    try {
      final places = await fetchSavedPlaces(); // saved_place_service.dart에서 가져옴
      setState(() {
        _savedPlaces = places;
        _isLoadingSavedPlaces = false;
      });
    } catch (e) {
      setState(() => _isLoadingSavedPlaces = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장된 장소를 불러오는데 실패했습니다: $e')),
      );
    }
  }
  Future<void> _loadTripsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList('savedTrips') ?? [];
    final List<Map<String, dynamic>> loaded = savedList.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();

    setState(() {
      savedTrips = loaded;
    });
  }

  Future<void> _saveTripsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = savedTrips.map((trip) => jsonEncode(trip)).toList();
    await prefs.setStringList('savedTrips', encoded);
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
        headers: {'Content-Type': 'application/json', 'Access_Token': accessToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          myInfo = data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (response.statusCode == 401) {
          await prefs.clear();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching profile: \$e');
    }
  }

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

      setState(() {
        reservations = res;
        isLoadingReservations = false;
      });
    } catch (e) {
      setState(() => isLoadingReservations = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약 목록 불러오기 실패: \$e')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) return;

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/logout');

    try {
      final response = await http.post(
        url,
        headers: {'Access_Token': accessToken},
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      debugPrint('Error during logout: \$e');
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
          : Column(
        children: [
          ProfileHeaderWidget(
            nickname: myInfo!['nickname'],
            email: myInfo!['email'],
            imgUrl: myInfo!['imgUrl'],
            level: myInfo!['level'],
            levelExp: myInfo!['levelExp'],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyTripsTab(),
                _buildReservationTab(),
                _buildSavedTab(),
                _buildReviewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildMyTripsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/make_trip'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
              ),
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
          const SizedBox(height: 16),

          if (savedTrips.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  '저장된 여행이 없습니다.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: savedTrips.map((trip) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: Container(
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
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 12,
                            child: const Icon(Icons.map, color: Colors.white),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 36,
                            child: Text(
                              trip['city'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 20,
                            child: Text(
                              '${trip['startDate']} ~ ${trip['endDate']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 8,
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
                                      hotels: trip['hotels'],
                                      transportation: trip['transportation'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: travelingPurple),
                              child: const Text('일정 보기', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }


  Widget _buildReservationTab() {
    if (isLoadingReservations) {
      return const Center(child: CircularProgressIndicator());
    }
    if (reservations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Text('예약 내역이 없습니다.', style: TextStyle(fontSize: 16, color: Colors.black54)),
        ),
      );
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
    if (_isLoadingSavedPlaces) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_savedPlaces.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Text('저장된 항목이 없습니다.', style: TextStyle(fontSize: 16, color: Colors.black54)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _savedPlaces.length,
      itemBuilder: (context, index) {
        final place = _savedPlaces[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 1.5,
          child: ListTile(
            title: Text(place.name),
            subtitle: Text('${place.city} · ${place.category}'),
            trailing: const Text('상세보기', style: TextStyle(color: travelingPurple)),
          ),
        );
      },
    );
  }


  Widget _buildReviewTab() {
    if (dummyReviews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Text('작성한 리뷰가 없습니다.', style: TextStyle(fontSize: 16, color: Colors.black54)),
        ),
      );
    }
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(email),
                Text(level),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            tooltip: '프로필 편집',
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
        ],
      ),
    );
  }
}
