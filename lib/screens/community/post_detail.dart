import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  static const Color travelingPurple = Color(0xFFA78BFA);
  bool _isLiked = false;
  int? _userId;
  bool _isLoading = true;
  bool _isProcessingLike = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchLikeStatus();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString('userInfo');
    if (userInfoString != null) {
      final Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      _userId = userInfo['id'];
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deletePost() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final postId = widget.post['id'];
    final url = Uri.parse('http://10.0.2.2:8080/api/posts/delete/$postId');

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Access_Token': accessToken,
        'Refresh': refreshToken ?? '',
      });

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('게시물이 삭제되었습니다.')),
          );
          Navigator.of(context).pop(true); // pop and optionally return true to indicate deletion
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('네트워크 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _fetchLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) return;
    final refreshToken = prefs.getString('refreshToken');

    final postId = widget.post['id'];
    final url = Uri.parse('http://10.0.2.2:8080/like/status/$postId');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Access_Token': accessToken,
        'Refresh': refreshToken ?? '',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bool isLiked = data['data'] == true;
        setState(() {
          _isLiked = isLiked;
        });
      }
    } catch (e) {
      // handle error silently
    }
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null) return '';
    try {
      final date = DateTime.parse(rawDate);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  Future<void> _toggleLike() async {
    if (_isProcessingLike) return;

    setState(() {
      _isProcessingLike = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) {
      setState(() {
        _isProcessingLike = false;
      });
      return;
    }

    final postId = widget.post['id'];
    final url = Uri.parse('http://10.0.2.2:8080/like/$postId');

    try {
      http.Response response;
      if (_isLiked) {
        response = await http.delete(url, headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        });
      } else {
        response = await http.post(url, headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        });
      }

      if (response.statusCode == 200) {
        setState(() {
          _isLiked = !_isLiked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('좋아요 요청에 실패했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('네트워크 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        _isProcessingLike = false;
      });
    }
  }

  void _navigateToEditPage() async {
    final updatedPost = await Navigator.pushNamed(
      context,
      '/write_post',
      arguments: widget.post,
    );

    if (updatedPost != null && mounted) {
      setState(() {
        widget.post.clear();
        widget.post.addAll(updatedPost as Map<String, dynamic>);
      });
      _fetchLikeStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final imageUrls = List<String>.from(post['imgUrl'] ?? []);
    final tags = (post['tags'] as List<dynamic>?)?.cast<String>() ?? [];

    final Map<String, dynamic>? writer = post['writer'] ?? post['user'];

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['userImgUrl'] != null || post['userName'] != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: post['userImgUrl'] != null
                        ? NetworkImage(post['userImgUrl'])
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: post['userImgUrl'] == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['userName'] ?? '익명',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            Text(
              post['title'] ?? '제목 없음',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              _formatDate(post['createdAt']),
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Text(
              post['content'] ?? '내용 없음',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            if (imageUrls.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageUrls.map((url) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.black,
                            insetPadding: const EdgeInsets.all(10),
                            child: InteractiveViewer(
                              child: Image.network(
                                url,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Text(
                                    "이미지를 불러올 수 없습니다",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Text("불러오기 실패"),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 16),

            if (tags.isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: tags
                    .map((tag) => Chip(
                  label: Text('#$tag'),
                  backgroundColor: travelingPurple.withOpacity(0.2),
                ))
                    .toList(),
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_userId != null && _userId == post['userId']) ...[
                  IconButton(
                    onPressed: _navigateToEditPage,
                    icon: const Icon(Icons.edit),
                    color: travelingPurple,
                    tooltip: '수정',
                  ),
                  IconButton(
                    onPressed: _isProcessingLike ? null : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('게시물 삭제'),
                          content: const Text('정말로 게시물을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await _deletePost();
                      }
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.redAccent,
                    tooltip: '삭제',
                  ),

                ] else ...[
                  IconButton(
                    onPressed: _isProcessingLike ? null : () async {
                      await _toggleLike();
                    },
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: travelingPurple,
                    tooltip: '좋아요',
                  ),
                  IconButton(
                    onPressed: () {
                      // 신고 로직
                    },
                    icon: const Icon(Icons.flag_outlined),
                    color: Colors.redAccent,
                    tooltip: '신고',
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
