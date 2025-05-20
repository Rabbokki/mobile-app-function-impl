import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _searchTerm = '';
  final List<String> _tabs = ['전체 보기', '꿀팁 게시판', '자유게시판', '여행메이트'];
  String _activeCategory = '전체 보기';

  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _searchController = TextEditingController();

    _tabController.addListener(() {
      setState(() {
        _activeCategory = _tabs[_tabController.index];
        _fetchPosts();
      });
    });

    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
        _fetchPosts();
      });
    });

    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final uri = Uri.parse('http://localhost:8080/api/posts').replace(queryParameters: {
      if (_activeCategory != '전체 보기') 'category': _activeCategory,
      if (_searchTerm.isNotEmpty) 'search': _searchTerm,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _posts = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              tabs: _tabs.map((label) => Tab(text: label)).toList(),
              isScrollable: true,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(post['title'] ?? ''),
                    subtitle: Text('${post['author'] ?? '작성자 없음'} · ${post['date'] ?? ''}'),
                    onTap: () {
                      // Navigate to detail screen
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
