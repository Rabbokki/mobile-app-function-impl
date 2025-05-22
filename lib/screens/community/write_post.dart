import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_app_function_impl/utils/post_service.dart';

class _RemovedImage {
  final String url;
  final int index;
  _RemovedImage(this.url, this.index);
}

class WritePostScreen extends StatefulWidget {
  final Map<String, dynamic>? postData;

  const WritePostScreen({super.key, this.postData});

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  static const Map<String, String> _categoryMapping = {
    'TIPS': '꿀팁 게시판',
    'FREE': '자유게시판',
    'MATE': '여행메이트',
  };

  late final Map<String, String> _reverseCategoryMapping;
  late final List<String> _categoryLabels;
  String? _selectedCategoryLabel;

  List<File> _imageFiles = [];
  List<String>? _imageUrls;
  int? _postId;

  static const Color travelingPurple = Color(0xFFA78BFA);
  final List<_RemovedImage> _removedImagesStack = [];

  @override
  void initState() {
    super.initState();

    _reverseCategoryMapping = {
      for (var entry in _categoryMapping.entries) entry.value: entry.key,
    };
    _categoryLabels = _categoryMapping.values.toList();

    final data = widget.postData;
    if (data != null) {
      _postId = data['id'];

      final backendCategoryKey = data['category'] as String?;
      _selectedCategoryLabel = backendCategoryKey != null
          ? _categoryMapping[backendCategoryKey]
          : null;

      _titleController.text = data['title'] ?? '';
      _contentController.text = data['content'] ?? '';
      _tagController.text = (data['tags'] as List?)?.join(', ') ?? '';

      _imageUrls = data['imgUrl'] != null
          ? (data['imgUrl'] is List
          ? List<String>.from(data['imgUrl'])
          : [data['imgUrl'] as String])
          : null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  void _removeImage(int index) {
    if (_imageUrls != null && index < _imageUrls!.length) {
      setState(() {
        final removedUrl = _imageUrls!.removeAt(index);
        _removedImagesStack.add(_RemovedImage(removedUrl, index));
      });
    } else if (_imageFiles.isNotEmpty && index >= (_imageUrls?.length ?? 0)) {
      setState(() {
        _imageFiles.removeAt(index - (_imageUrls?.length ?? 0));
      });
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('이미지가 삭제되었습니다.'),
        action: SnackBarAction(
          label: '실행 취소',
          onPressed: _undoRemoveImage,
        ),
      ),
    );
  }

  void _undoRemoveImage() {
    if (_removedImagesStack.isEmpty) return;

    final lastRemoved = _removedImagesStack.removeLast();
    setState(() {
      _imageUrls!.insert(lastRemoved.index, lastRemoved.url);
    });
  }

  Widget _buildImagePreview() {
    final combinedImages = [
      if (_imageUrls != null) ..._imageUrls!,
      ..._imageFiles.map((e) => e.path),
    ];

    // We add one more item for the '+' button
    final itemCount = combinedImages.length + 1;

    if (combinedImages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text('이미지를 선택하거나 첨부하세요'),
          ],
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == combinedImages.length) {
            return Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }

          final isNetwork = index < (_imageUrls?.length ?? 0);
          final imageWidget = isNetwork
              ? Image.network(
            combinedImages[index],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          )
              : Image.file(
            File(combinedImages[index]),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          );

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget,
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> createPostRequest({
    required Map<String, dynamic> dto,
    required List<File> imageFiles,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse('http://10.0.2.2:8080/api/posts/create');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Access_Token': accessToken,
      'Refresh': refreshToken,
    });

    request.files.add(http.MultipartFile.fromString(
      'dto',
      jsonEncode(dto),
      contentType: MediaType('application', 'json'),
    ));

    for (File file in imageFiles) {
      final mimeType = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];
      request.files.add(await http.MultipartFile.fromPath(
        'postImg',
        file.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      debugPrint('게시글 생성 성공');

      final Map<String, dynamic> responseData =
      json.decode(utf8.decode(response.bodyBytes));

      return responseData;
    } else {
      debugPrint('게시글 생성 실패: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
      throw Exception('게시글 생성 실패');
    }
  }

  Future<void> updatePostRequest({
    required int postId,
    required Map<String, dynamic> dto,
    required List<File> imageFiles,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse('http://10.0.2.2:8080/api/posts/update/$postId');
    final request = http.MultipartRequest('PATCH', uri);

    request.headers.addAll({
      'Access_Token': accessToken,
      'Refresh': refreshToken,
    });

    request.files.add(http.MultipartFile.fromString(
      'dto',
      jsonEncode(dto),
      contentType: MediaType('application', 'json'),
    ));

    request.files.add(http.MultipartFile.fromString(
      'remainImgUrl',
      jsonEncode(_imageUrls ?? []),
      contentType: MediaType('application', 'json'),
    ));

    for (File file in imageFiles) {
      final mimeType = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];
      request.files.add(await http.MultipartFile.fromPath(
        'postImg',
        file.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      debugPrint('게시글 수정 성공');
    } else {
      debugPrint('게시글 수정 실패: ${response.statusCode}, ${json.decode(utf8.decode(response.bodyBytes))}');
      throw Exception('게시글 수정 실패');
    }
  }

  Future<Map<String, dynamic>> fetchPostById(int postId) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/posts/find/$postId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> postMap = json.decode(utf8.decode(response.bodyBytes));
      return postMap;
    } else {
      throw Exception('Failed to fetch post with id $postId');
    }
  }

  void _submitPost() async {
    if (_selectedCategoryLabel == null ||
        _titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시판, 제목, 내용을 모두 입력해주세요.')),
      );
      return;
    }

    final backendCategoryKey = _reverseCategoryMapping[_selectedCategoryLabel!]!;

    final dto = {
      'category': backendCategoryKey,
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'tags': _tagController.text.trim().split(',').map((e) => e.trim()).toList(),
    };

    final prefs = await SharedPreferences.getInstance();

    try {
      if (_postId != null) {
        await updatePostRequest(
          postId: _postId!,
          dto: dto,
          imageFiles: _imageFiles,
          accessToken: prefs.getString('accessToken') ?? '',
          refreshToken: prefs.getString('refreshToken') ?? '',
        );

        final post = await fetchPostById(_postId!);
        Navigator.pop(context, post);
      } else {
        final newPost = await createPostRequest(
          dto: dto,
          imageFiles: _imageFiles,
          accessToken: prefs.getString('accessToken') ?? '',
          refreshToken: prefs.getString('refreshToken') ?? '',
        );
        Navigator.pop(context, newPost);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글 수정 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postData != null ? '글 수정' : '글쓰기'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '게시판 선택',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategoryLabel,
              items: _categoryLabels
                  .map((label) => DropdownMenuItem(
                value: label,
                child: Text(label),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategoryLabel = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: '내용',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImagePreview(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: '태그 (쉼표로 구분)',
                hintText: '예: 도쿄, 일본, 맛집',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: travelingPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.postData != null ? '수정하기' : '등록하기',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
