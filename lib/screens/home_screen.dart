import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 로고 및 알림 아이콘
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Traveling',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Icon(Icons.notifications_none, color: Colors.grey),
                ],
              ),
            ),

            // 주요 기능 메뉴 아이콘들 - 2줄로 나누기
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MainIconButton(
                        icon: Icons.flight_takeoff,
                        label: '항공권',
                        onTap: () {
                          Navigator.pushNamed(context, '/flight');
                        },
                      ),
                      _MainIconButton(
                        icon: Icons.create_rounded,
                        label: '여행만들기',
                        onTap: () {
                          Navigator.pushNamed(context, '/make_trip');
                        },
                      ),
                      _MainIconButton(
                        icon: Icons.place,
                        label: '추천 명소',
                        onTap: () {
                          Navigator.pushNamed(context, '/recommended');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MainIconButton(
                        icon: Icons.forum,
                        label: '커뮤니티',
                        onTap: () {
                          Navigator.pushNamed(context, '/community');
                        },
                      ),
                      _MainIconButton(
                        icon: Icons.person,
                        label: '마이페이지',
                        onTap: () {
                          Navigator.pushNamed(context, '/mypage');
                        },
                      ),
                      _MainIconButton(
                        icon: Icons.login,
                        label: '로그인',
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      _MainIconButton(
                        icon: Icons.person_add,
                        label: '회원가입',
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 하단 네비게이션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BottomNavItem(icon: Icons.home, label: '홈'),
                  _BottomNavItem(icon: Icons.calendar_today, label: '일정'),
                  _BottomNavItem(icon: Icons.person_outline, label: '내정보'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MainIconButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            radius: 28,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
