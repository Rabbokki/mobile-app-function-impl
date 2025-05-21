import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Add http package in pubspec.yaml

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const Color travelingPurple = Color(0xFFA78BFA);
  static const List<String> tabs = ['전체 보기', '꿀팁 게시판', '자유게시판', '여행메이트'];

  List<Map<String, dynamic>> posts = [];
  bool isLoading = false;
  String currentCategory = '';
  String currentSearch = '';

  // Map tab label to backend category
  Map<String, String?> categoryMap = {
    '전체 보기': null,
    '꿀팁 게시판': 'TIPS',
    '자유게시판': 'FREE',
    '여행메이트': 'MATE',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initially load all posts
    _fetchPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      currentCategory = categoryMap[tabs[_tabController.index]] ?? '';
      _fetchPosts();
    });
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Build URL with query params
      final queryParameters = <String, String>{};
      if (currentCategory.isNotEmpty) {
        queryParameters['category'] = currentCategory;
      }
      if (currentSearch.isNotEmpty) {
        queryParameters['search'] = currentSearch;
      }

      final uri = Uri.http(
        '10.0.2.2:8080', // <-- replace with your backend host (without http/s)
        '/api/posts',
        queryParameters.isEmpty ? null : queryParameters,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          posts = data.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        debugPrint('Failed to fetch posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearch() {
    setState(() {
      currentSearch = _searchController.text.trim();
      _fetchPosts();
    });
  }

  void _onWritePost() async {
    final result = await Navigator.pushNamed(context, '/write_post');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        posts.insert(0, result); // Add new post on top locally
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
                    onSubmitted: (_) => _onSearch(),
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 1,
                  child: ListTile(
                    title: Text(post['title'] ?? ''),
                    subtitle: Text('작성자: ${post['userName'] ?? '익명'}'),
                    onTap: () async {
                      print('biang');
                      try {
                        final response = await http.get(
                          Uri.parse("http://10.0.2.2:8080/api/posts/find/${post['id']}"),
                        );

                        if (response.statusCode == 200) {
                          final post = json.decode(utf8.decode(response.bodyBytes));

                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              '/post_detail',
                              arguments: post,
                            );
                          }
                        } else {
                          throw Exception('상태 코드: ${response.statusCode}');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('게시글 불러오기 실패: $e')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
