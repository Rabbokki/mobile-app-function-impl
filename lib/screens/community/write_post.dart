import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Helper class to store removed image and index
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
  File? _imageFile;
  List<String>? _imageUrls; // Changed from single imageUrl to list for multiple images
  int? _postId;

  static const Color travelingPurple = Color(0xFFA78BFA);

  // Stack to keep removed images and their positions for undo
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

      _imageUrls = data['imageUrl'] != null
          ? (data['imageUrl'] is List
          ? List<String>.from(data['imageUrl'])
          : [data['imageUrl'] as String])
          : null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _imageUrls = null; // Clear old image URLs when a new image is picked
      });
    }
  }

  // Method to remove an image by index
  void _removeImage(int index) {
    if (_imageUrls == null) return;

    setState(() {
      final removedUrl = _imageUrls!.removeAt(index);
      _removedImagesStack.add(_RemovedImage(removedUrl, index));
    });

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

  // Undo the last removal
  void _undoRemoveImage() {
    if (_removedImagesStack.isEmpty) return;

    final lastRemoved = _removedImagesStack.removeLast();
    setState(() {
      _imageUrls!.insert(lastRemoved.index, lastRemoved.url);
    });
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity);
    } else if (_imageUrls != null && _imageUrls!.isNotEmpty) {
      // Show all images as horizontal scrollable thumbnails
      return SizedBox(
        height: 100, // fixed height for thumbnails container
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: _imageUrls!.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final url = _imageUrls![index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                // Positioned X button
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      decoration: BoxDecoration(
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
    } else {
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
  }

  void _submitPost() {
    if (_selectedCategoryLabel == null ||
        _titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시판, 제목, 내용을 모두 입력해주세요.')),
      );
      return;
    }

    final backendCategoryKey = _reverseCategoryMapping[_selectedCategoryLabel!]!;

    final postData = {
      'id': _postId,
      'category': backendCategoryKey,
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'tags': _tagController.text.trim().split(',').map((e) => e.trim()).toList(),
      'imagePath': _imageFile?.path,
      'imageUrl': List<String>.from(_imageUrls ?? []),
    };

    debugPrint(widget.postData != null ? '🟣 수정된 게시글:' : '🟣 새 게시글:');
    debugPrint(postData.toString());

    Navigator.pop(context, postData);
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
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
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
