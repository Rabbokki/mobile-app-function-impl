import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color travelingPurple = Color(0xFFA78BFA);
  static const Color lightPurple = Color(0xFFEDE9FE);
  static const Color backgroundColor = Color(0xFFF9FAFB);

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken');

    setState(() {
      isLoggedIn = accessToken != null && accessToken.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.black87),
                    onPressed: () {
                      if (isLoggedIn) {
                        Navigator.pushNamed(context, '/mypage');
                      } else {
                        Navigator.pushNamed(context, '/login');
                      }
                    },
                  ),
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

            // Feature Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _MainFeatureButton(icon: Icons.flight, label: '항공권', onTap: () {
                    Navigator.pushNamed(context, '/flight');
                  }),
                  _MainFeatureButton(icon: Icons.edit, label: '여행만들기', onTap: () {
                    Navigator.pushNamed(context, '/make_trip');
                  }),
                  _MainFeatureButton(icon: Icons.place, label: '추천 명소', onTap: () {
                    Navigator.pushNamed(context, '/recommended');
                  }),
                  _MainFeatureButton(icon: Icons.chat_bubble_outline, label: '커뮤니티', onTap: () {
                    Navigator.pushNamed(context, '/community');
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Spacer(),

            // Bottom Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavItem(
                    icon: Icons.home,
                    label: '홈',
                    isActive: true,
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  _BottomNavItem(
                    icon: Icons.person,
                    label: '마이페이지',
                    onTap: () {
                      Navigator.pushNamed(context, '/mypage');
                    },
                  ),
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
  final VoidCallback? onTap;

  const _MainFeatureButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFE9D5FF), Color(0xFFA78BFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// --- 하단 네비게이션 바 아이템
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
    super.key,
  });

  static const Color travelingPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: isActive ? travelingPurple : Colors.grey.shade400,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? travelingPurple : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
