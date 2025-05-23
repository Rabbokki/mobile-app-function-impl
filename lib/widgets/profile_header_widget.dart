import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final String nickname;
  final String email;
  final String? imgUrl;
  final String level; // 여전히 영문 레벨 키값을 전달받는다면 여기 바꿔도 됨
  final int levelExp;

  const ProfileHeaderWidget({
    Key? key,
    required this.nickname,
    required this.email,
    this.imgUrl,
    required this.level,
    required this.levelExp,
  }) : super(key: key);

  @override
  _ProfileHeaderWidgetState createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  bool _showLevelDialog = false;
  bool _showExpDialog = false;

  final Map<String, Map<String, int>> levelInfo = {
    'Lv.1 여행 새싹': {'min': 0, 'max': 99},
    'Lv.2 초보 여행자': {'min': 100, 'max': 199},
    'Lv.3 탐험가': {'min': 200, 'max': 299},
    'Lv.4 모험가': {'min': 300, 'max': 399},
    'Lv.5 세계 여행자': {'min': 400, 'max': 499},
    'Lv.6 여행 달인': {'min': 500, 'max': 599},
    '🏆 전설의 여행자': {'min': 600, 'max': 9999},
  };

  String getTravelLevel(int exp) {
    for (final entry in levelInfo.entries) {
      final min = entry.value['min']!;
      final max = entry.value['max']!;
      if (exp >= min && exp <= max) return entry.key;
    }
    return 'Lv.0 미정';
  }

  @override
  Widget build(BuildContext context) {
    final String travelLevel = getTravelLevel(widget.levelExp);
    final Map<String, int> tier = levelInfo[travelLevel]!;
    final int minExp = tier['min']!;
    final int maxExp = tier['max']!;
    final int progress = ((widget.levelExp - minExp) / (maxExp - minExp + 1) * 100).clamp(0, 100).toInt();
    final bool isMax = widget.levelExp >= 600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.imgUrl != null && widget.imgUrl!.isNotEmpty
                    ? NetworkImage(widget.imgUrl!)
                    : null,
                child: widget.imgUrl == null || widget.imgUrl!.isEmpty
                    ? Icon(Icons.person, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.nickname, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                    const SizedBox(height: 4),
                    Text(widget.email, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => setState(() => _showLevelDialog = true),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '여행 레벨: $travelLevel',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.info_outline, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _showExpDialog = true),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$progress%', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
              ),
            ],
          ),
          if (_showLevelDialog) _buildLevelDialog(),
          if (_showExpDialog) _buildExpDialog(),
        ],
      ),
    );
  }

  Widget _buildLevelDialog() {
    return _buildDialog(
      title: '🌟 여행 레벨 안내',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: levelInfo.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              '${e.key}: ${e.value['min']}~${e.value['max']} exp',
              style: TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
      ),
      onClose: () => setState(() => _showLevelDialog = false),
    );
  }

  Widget _buildExpDialog() {
    return _buildDialog(
      title: '💡 경험치(Exp)란?',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('경험치는 여행 활동을 할 때마다 자동으로 쌓입니다.'),
          SizedBox(height: 8),
          Text('예시:'),
          SizedBox(height: 4),
          Text('- 여행 일정 만들기 +20'),
          Text('- 명소 추가하기 +5'),
          Text('- 커뮤니티 글 작성 +15'),
          Text('- 리뷰 작성 +20'),
        ],
      ),
      onClose: () => setState(() => _showExpDialog = false),
    );
  }

  Widget _buildDialog({
    required String title,
    required Widget content,
    required VoidCallback onClose,
  }) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            content,
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClose,
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}
