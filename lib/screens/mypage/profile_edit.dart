import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  String _gender = '남성';
  DateTime _birthDate = DateTime.now();
  String _imgUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfoFromServer();
  }

  Future<void> _loadUserInfoFromServer() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) return;

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/mypage');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Access_Token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _nicknameController.text = data['nickname'] ?? '';
        _emailController.text = data['email'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _gender = data['gender'] ?? '남성';
        _birthDate = DateTime.tryParse(data['birthday'] ?? '') ?? DateTime(2000);
        _imgUrl = data['imgUrl'] ?? '';
      });
    } else {
      debugPrint('유저 정보 불러오기 실패: ${response.body}');
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) return;

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/mypage');

    final body = jsonEncode({
      'nickname': _nicknameController.text,
      'bio': _bioController.text,
      'gender': _gender,
      'birthday': DateFormat('yyyy-MM-dd').format(_birthDate),
      'imgUrl': '',
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 수정되었습니다')),
        );
        Navigator.pop(context);
      } else {
        debugPrint('저장 실패: ${response.body}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${response.body}')),
        );
      }
    } catch (e) {
      debugPrint('네트워크 오류: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _imgUrl.isNotEmpty ? NetworkImage(_imgUrl) : null,
              child: _imgUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '자기소개'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: '성별'),
              items: ['남성', '여성', '기타'].map((g) {
                return DropdownMenuItem(value: g, child: Text(g));
              }).toList(),
              onChanged: (val) => setState(() => _gender = val!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: '생년월일',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _birthDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _birthDate = picked);
                    }
                  },
                ),
              ),
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(_birthDate),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('저장하기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
