import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final String nickname;
  final String email;
  final String? imgUrl;
  final String level;
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
    'BEGINNER': {'min': 0,   'max': 99},
    'NOVICE':   {'min': 100, 'max': 199},
    'EXPLORER': {'min': 200, 'max': 299},
    'ADVENTURER': {'min': 300, 'max': 399},
    'WORLD_TRAVELER': {'min': 400, 'max': 499},
    'MASTER':   {'min': 500, 'max': 599},
    'LEGEND':   {'min': 600, 'max': 9999},
  };

  @override
  Widget build(BuildContext context) {
    final tier = levelInfo[widget.level] ?? levelInfo['BEGINNER']!;
    final int minExp = tier['min']!;
    final int maxExp = tier['max']!;
    final int progress = ((widget.levelExp - minExp) / (maxExp - minExp + 1) * 100).clamp(0, 100).toInt();
    final int displayLvl = (widget.levelExp ~/ 100) + 1;
    final bool isMax = displayLvl >= 7;

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
                    Row(
                      children: [
                        Text('여행 레벨: ${widget.level}', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() => _showLevelDialog = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isMax ? '🏆 MAX' : 'Lv.$displayLvl',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
                onPressed: () => Navigator.pushNamed(context, '/profile-edit'),
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
              'Lv.${e.key.replaceAll('_', ' ')}: ${e.value['min']}~${e.value['max']} exp',
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
