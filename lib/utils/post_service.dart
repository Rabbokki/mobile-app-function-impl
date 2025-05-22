import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Replace with your backend base URL or inject it
const String baseUrl = 'http://10.0.2.2:8080';

/// Create a post
Future<void> createPostRequest({
  required Map<String, dynamic> dto,
  required List<File> imageFiles,
  required String accessToken,
  required String refreshToken,
}) async {
  final uri = Uri.parse('$baseUrl/api/posts/create');
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
    // Success
    print('게시글 생성 성공');
  } else {
    print('게시글 생성 실패: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
    throw Exception('게시글 생성 실패');
  }
}

/// Update a post
Future<void> updatePostRequest({
  required int postId,
  required Map<String, dynamic> dto,
  required List<String> remainImgUrls,
  required List<File> imageFiles,
  required String accessToken,
  required String refreshToken,
}) async {
  final uri = Uri.parse('$baseUrl/api/posts/update/$postId');
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
    jsonEncode(remainImgUrls),
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
    print('게시글 수정 성공');
  } else {
    print('게시글 수정 실패: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
    throw Exception('게시글 수정 실패');
  }
}

/// Fetch a post by ID
Future<Map<String, dynamic>> fetchPostById(int postId) async {
  final url = Uri.parse('$baseUrl/api/posts/find/$postId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  } else {
    throw Exception('게시글 불러오기 실패 (id: $postId)');
  }
}
