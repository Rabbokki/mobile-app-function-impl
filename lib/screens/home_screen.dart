import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color travelingPurple = Color(0xFFA78BFA);
  static const Color lightPurple = Color(0xFFEDE9FE);
  static const Color backgroundColor = Color(0xFFF9FAFB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 상단: 로고 + 로그인/회원가입
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Traveling',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: travelingPurple,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('로그인', style: TextStyle(color: Colors.black87)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('회원가입', style: TextStyle(color: Colors.black45)),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 24.0, bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '✈️ 세상 모든 여행을 한눈에!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // 기능 버튼들
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  _MainFeatureButton(icon: Icons.flight, label: '항공권'),
                  _MainFeatureButton(icon: Icons.edit, label: '여행만들기'),
                  _MainFeatureButton(icon: Icons.place, label: '추천 명소'),
                  _MainFeatureButton(icon: Icons.chat_bubble_outline, label: '커뮤니티'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 인기 여행지 추천 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🧳 인기 여행지 추천',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('도쿄 · 파리 · 방콕',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightPurple,
                        foregroundColor: travelingPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('추천 명소 보기'),
                    )
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 하단 네비게이션 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BottomNavItem(icon: Icons.home, label: '홈', isActive: true),
                  _BottomNavItem(icon: Icons.person, label: '마이페이지'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 기능 버튼 위젯
class _MainFeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MainFeatureButton({
    required this.icon,
    required this.label,
    super.key,
  });

  static const Color jellyPurple = Color(0xFFD8B4FE); // 연보라 배경
  static const Color iconPurple = Color(0xFFA78BFA);  // 메인 보라

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 젤리 스타일 원형 버튼
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE9D5FF), Color(0xFFA78BFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33212121),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 하단 네비게이션 바 아이템
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    super.key,
  });

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 28, // ✔️ 크기 증가
          color: isActive ? travelingPurple : Colors.grey.shade400,
        ),
        const SizedBox(height: 6), // ✔️ 여백 증가
        Text(
          label,
          style: TextStyle(
            fontSize: 13, // ✔️ 폰트 키움
            fontWeight: FontWeight.w500,
            color: isActive ? travelingPurple : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
