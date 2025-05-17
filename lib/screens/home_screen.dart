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
            // 상단 로고 및 아이콘 메뉴
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

            // 주요 기능 메뉴 (항공권/호텔/렌터카 등)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MainIconButton(icon: Icons.flight, label: '항공권'),
                  _MainIconButton(icon: Icons.hotel, label: '호텔'),
                  _MainIconButton(icon: Icons.directions_car, label: '렌터카'),
                ],
              ),
            ),

            // 카드 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _FeatureCard(title: '어디든지 검색', icon: Icons.explore),
                    SizedBox(width: 12),
                    _FeatureCard(title: '호텔 초특가', icon: Icons.local_offer),
                    SizedBox(width: 12),
                    _FeatureCard(title: '12가지 여행법', icon: Icons.tips_and_updates),
                  ],
                ),
              ),
            ),

            // 하단 네비게이션 메뉴 자리 확보용 Spacer
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
                  _BottomNavItem(icon: Icons.home, label: '둘러보기'),
                  _BottomNavItem(icon: Icons.calendar_today, label: '여행 일정'),
                  _BottomNavItem(icon: Icons.person_outline, label: '프로필'),
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

  const _MainIconButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          radius: 24,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _FeatureCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
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
