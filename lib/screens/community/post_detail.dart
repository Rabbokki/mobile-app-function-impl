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
  String? _userName;
  bool _isLoading = true;
  bool _isProcessingLike = false;

  List<Map<String, dynamic>> _comments = [];
  bool _isCommentLoading = false;
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingComment = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchLikeStatus();   // Fetch only post-like status
    _fetchComments();     // This will also call _fetchLikesStatus for post & comments
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString('userInfo');
    if (userInfoString != null) {
      final Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      _userId = userInfo['id'];
      _userName = userInfo['nickname'];
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
          Navigator.of(context).pop(true);
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
        final bool isLiked = (data['data'] == true);
        setState(() {
          _isLiked = isLiked;
        });
      }
    } catch (_) {
      // handle error silently
    }
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isCommentLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) {
      setState(() {
        _isCommentLoading = false;
      });
      return;
    }

    final postId = widget.post['id'];
    final url = Uri.parse('http://10.0.2.2:8080/api/comment/posts/$postId/comments');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Access_Token': accessToken,
        'Refresh': refreshToken ?? '',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _comments = data.cast<Map<String, dynamic>>();
        });

        // Build a List<int> of comment IDs
        final List<int> commentIds = _comments
            .map((commentMap) => commentMap['id'] as int)
            .toList();

        // Now fetch like status for both the post and its comments
        _fetchLikesStatus(postId, commentIds);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 불러오기 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 불러오기 중 네트워크 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        _isCommentLoading = false;
      });
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty || _isPostingComment) return;

    setState(() {
      _isPostingComment = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      setState(() {
        _isPostingComment = false;
      });
      return;
    }

    final postId = widget.post['id'];
    final url = Uri.parse('http://10.0.2.2:8080/api/comment/posts/$postId/comment');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        },
        body: json.encode({
          'content': _commentController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        _commentController.clear();
        await _fetchComments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 작성 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 작성 중 네트워크 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        _isPostingComment = false;
      });
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8080/api/comment/delete/$commentId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        },
      );

      if (response.statusCode == 200) {
        await _fetchComments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글이 삭제되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 삭제 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 삭제 중 네트워크 오류가 발생했습니다.')),
      );
    }
  }

  Future<bool> _confirmDeleteDialog() async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('정말 이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    )) ??
        false;
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

  Future<void> _fetchLikesStatus(int postId, List<int> commentIds) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken == null) return;

    try {
      // 1. Fetch post like status
      final postLikeUrl = Uri.parse('http://10.0.2.2:8080/like/status/$postId');
      final postResponse = await http.get(postLikeUrl, headers: {
        'Content-Type': 'application/json',
        'Access_Token': accessToken,
        'Refresh': refreshToken ?? '',
      });

      if (postResponse.statusCode == 200) {
        final postLikeData = jsonDecode(postResponse.body);
        final isPostLiked = postLikeData['data'];
        setState(() {
          widget.post['likedByUser'] = isPostLiked;
        });
      }

      // 2. Fetch each comment like status
      for (int i = 0; i < commentIds.length; i++) {
        final commentId = commentIds[i];
        final commentLikeUrl =
        Uri.parse('http://10.0.2.2:8080/like/commentStatus/$commentId');

        final commentResponse = await http.get(commentLikeUrl, headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        });

        if (commentResponse.statusCode == 200) {
          final likeData = jsonDecode(commentResponse.body);
          final isLiked = likeData['data'];
          setState(() {
            _comments[i]['likedByUser'] = isLiked;
          });
        }
      }
    } catch (error) {
      debugPrint('Error fetching like statuses: $error');
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
        response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Access_Token': accessToken,
            'Refresh': refreshToken ?? '',
          },
        );
      } else {
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Access_Token': accessToken,
            'Refresh': refreshToken ?? '',
          },
        );
      }

      if (response.statusCode == 200) {
        setState(() {
          _isLiked = !_isLiked;
          // Update the local likeCount so UI shows the new count immediately
          final currentCount = widget.post['likeCount'] as int? ?? 0;
          widget.post['likeCount'] = _isLiked ? currentCount + 1 : currentCount - 1;
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

  Future<void> _toggleCommentLike(int commentId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) return;

    final isLiked = _comments[index]['likedByUser'] == true;
    final url = Uri.parse('http://10.0.2.2:8080/like/comment/$commentId');

    try {
      final response = isLiked
          ? await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        },
      )
          : await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh': refreshToken ?? '',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _comments[index]['likedByUser'] = !isLiked;
          // Update the local likeCount for this comment
          final currentCount = _comments[index]['likeCount'] as int? ?? 0;
          _comments[index]['likeCount'] = isLiked ? currentCount - 1 : currentCount + 1;
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 좋아요 처리 중 오류가 발생했습니다.')),
      );
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
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
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
                    onPressed: _isProcessingLike
                        ? null
                        : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('게시물 삭제'),
                          content: const Text(
                              '정말로 게시물을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('취소')),
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('삭제')),
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
                    onPressed: _isProcessingLike
                        ? null
                        : () async {
                      await _toggleLike();
                    },
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: travelingPurple,
                    tooltip: '좋아요',
                  ),
                  // Display the post’s like count
                  Text(
                    '${post['likeCount'] ?? 0}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
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

            Row(
              children: const [
                Icon(Icons.chat_bubble_outline, size: 20, color: Colors.blue),
                SizedBox(width: 6),
                Text('댓글',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 12),

            if (_isCommentLoading)
              const Center(child: CircularProgressIndicator())
            else if (_comments.isEmpty)
              const Text('등록된 댓글이 없습니다.')
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  final writerName = comment['author'] ?? '익명';
                  final content = comment['content'] ?? '';
                  final createdAt = comment['createdAt'] ?? '';
                  String formattedDate = '';
                  try {
                    final date = DateTime.parse(createdAt);
                    formattedDate =
                    '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
                  } catch (_) {}

                  final isOwnComment = _userId != null &&
                      writerName != null &&
                      _userName == writerName;

                  final bool commentLiked =
                      (comment['likedByUser'] as bool?) ?? false;
                  final int commentLikeCount =
                      comment['likeCount'] as int? ?? 0;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: comment['authorImage'] != null
                          ? NetworkImage(comment['authorImage'])
                          : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
                    ),
                    title: Text(writerName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Comment like button
                        IconButton(
                          icon: Icon(
                            commentLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: travelingPurple,
                          ),
                          onPressed: () {
                            _toggleCommentLike(comment['id'] as int, index);
                          },
                        ),

                        // Comment like count
                        Text(
                          '$commentLikeCount',
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(width: 12),

                        // Date
                        Text(formattedDate,
                            style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),

                        // Delete button for own comment
                        if (isOwnComment) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () async {
                              final confirmed = await _confirmDeleteDialog();
                              if (confirmed) {
                                await _deleteComment(comment['id'] as int);
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isPostingComment ? null : _postComment,
                  child: _isPostingComment
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('등록'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
