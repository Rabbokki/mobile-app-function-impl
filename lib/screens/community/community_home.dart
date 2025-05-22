import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const Color travelingPurple = Color(0xFFA78BFA);
  static const List<String> tabs = ['전체 보기', '꿀팁 게시판', '자유게시판', '여행메이트'];

  List<Map<String, dynamic>> posts = [];
  bool isLoading = false;
  String currentCategory = '';
  String currentSearch = '';

  // Pagination
  int currentPage = 0;
  static const int pageSize = 10;

  // Map tab label to backend category
  final Map<String, String?> categoryMap = {
    '전체 보기': null,
    '꿀팁 게시판': 'TIPS',
    '자유게시판': 'FREE',
    '여행메이트': 'MATE',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(_handleTabChange);
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
      currentPage = 0;
      _fetchPosts();
    });
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoading = true;
      currentPage = 0;
    });

    try {
      final queryParameters = <String, String>{};
      if (currentCategory.isNotEmpty) {
        queryParameters['category'] = currentCategory;
      }
      if (currentSearch.isNotEmpty) {
        queryParameters['search'] = currentSearch;
      }

      final uri = Uri.http(
        '10.0.2.2:8080',
        '/api/posts',
        queryParameters.isEmpty ? null : queryParameters,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data =
        json.decode(utf8.decode(response.bodyBytes));

        // Sort by createdAt descending
        data.sort((a, b) {
          final dateA = DateTime.parse(a['createdAt'] ?? '');
          final dateB = DateTime.parse(b['createdAt'] ?? '');
          return dateB.compareTo(dateA);
        });

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
      currentPage = 0;
      _fetchPosts();
    });
  }

  void _onWritePost() async {
    final result = await Navigator.pushNamed(context, '/write_post');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        // Insert the newly written post at the top of the list
        posts.insert(0, result);
        currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Compute the subset of posts to display for current page
    final startIndex = currentPage * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, posts.length);
    final pagedPosts = posts.isEmpty
        ? <Map<String, dynamic>>[]
        : posts.sublist(startIndex, endIndex);

    final bool hasPrev = currentPage > 0;
    final bool hasNext = endIndex < posts.length;

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
          ),
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
          // Search bar
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
                    onChanged: (value) {
                      setState(() {
                        currentSearch = value;
                        currentPage = 0;
                      });
                      _fetchPosts(); // Live search as text changes
                    },
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
              ],
            ),
          ),

          // Post list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: pagedPosts.length,
              itemBuilder: (context, index) {
                final post = pagedPosts[index];
                final String title = post['title'] ?? '';
                final String author = post['userName'] ?? '익명';
                final int likeCount = post['likeCount'] as int? ?? 0;
                final int viewCount = post['views'] as int? ?? 0;
                final int commentCount =
                    post['commentsCount'] as int? ?? 0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 1,
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text('작성자: $author'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Views
                        const Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$viewCount',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 16),

                        // Comments
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$commentCount',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 16),

                        // Likes (unfilled outline)
                        const Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$likeCount',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () async {
                      try {
                        final detailResponse = await http.get(
                          Uri.parse(
                            'http://10.0.2.2:8080/api/posts/find/${post['id']}',
                          ),
                        );

                        if (detailResponse.statusCode == 200) {
                          final Map<String, dynamic> postDetail =
                          json.decode(
                              utf8.decode(detailResponse.bodyBytes));

                          if (!mounted) return;
                          final result = await Navigator.pushNamed(
                            context,
                            '/post_detail',
                            arguments: postDetail,
                          );

                          if (result == true) {
                            _fetchPosts();
                          }
                        } else {
                          throw Exception(
                            '상태 코드: ${detailResponse.statusCode}',
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('게시글 불러오기 실패: $e'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Pagination controls
          if (!isLoading && posts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: hasPrev
                        ? () {
                      setState(() {
                        currentPage -= 1;
                      });
                    }
                        : null,
                    child: const Text('이전'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '페이지 ${currentPage + 1} / '
                        '${(posts.length / pageSize).ceil()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: hasNext
                        ? () {
                      setState(() {
                        currentPage += 1;
                      });
                    }
                        : null,
                    child: const Text('다음'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
