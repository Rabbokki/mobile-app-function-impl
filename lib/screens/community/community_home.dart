import 'package:flutter/material.dart';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const Color travelingPurple = Color(0xFFA78BFA);
  static const List<String> tabs = ['꿀팁 게시판', '자유게시판', '여행메이트'];

  List<Map<String, dynamic>> dummyPosts = [
    {'title': '여행 짐싸는 꿀팁', 'author': '유저1'},
    {'title': '혼자 도쿄 가기 후기', 'author': '유저2'},
    {'title': '유럽 저가항공 총정리', 'author': '유저3'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    debugPrint('검색어: ${_searchController.text}');
  }

  void _onWritePost() async {
    final result = await Navigator.pushNamed(context, '/write_post');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        dummyPosts.insert(0, result); // 새 글을 맨 위에 추가
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('커뮤니티'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: _onWritePost,
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((label) => Tab(text: label)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '검색어를 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: travelingPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: const Text('검색'),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((label) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: dummyPosts.length,
                  itemBuilder: (context, index) {
                    final post = dummyPosts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 1,
                      child: ListTile(
                        title: Text(post['title'] ?? ''),
                        subtitle: Text('작성자: ${post['author'] ?? '익명'}'),
                        onTap: () {
                          debugPrint('클릭한 게시글: ${post['title']}');
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
