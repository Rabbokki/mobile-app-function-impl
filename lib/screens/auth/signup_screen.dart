// 상단 import 유지
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final introController = TextEditingController();

  DateTime? birthday;
  String? gender;
  File? _profileImage;

  bool agreeTerms = false;
  bool agreeMarketing = false;

  static const Color travelingPurple = Color(0xFFA78BFA);
  static const Color backgroundColor = Color(0xFFF9FAFB);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<void> _selectBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthday = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이용약관에 동의해주세요.')),
      );
      return;
    }

    try {
      final formData = FormData.fromMap({
        'email': emailController.text,
        'name': nameController.text,
        'nickname': nicknameController.text,
        'password': passwordController.text,
        'birthday': birthday?.toIso8601String(),
        'gender': gender,
        'intro': introController.text,
        'agreeTerms': agreeTerms.toString(),
        'agreeMarketing': agreeMarketing.toString(),
        if (_profileImage != null)
          'profileImage': await MultipartFile.fromFile(
            _profileImage!.path,
            filename: 'profile.jpg',
          ),
      });

      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:8080/api/account/signup', // 주소 확인
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      print('회원가입 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: travelingPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 12),
              Text('프로필 사진 등록', style: TextStyle(fontSize: 14, color: travelingPurple)),
              const SizedBox(height: 20),

              _buildTextField(emailController, '이메일', keyboardType: TextInputType.emailAddress),
              _buildTextField(nameController, '이름'),
              _buildTextField(nicknameController, '닉네임'),
              _buildDateField(),
              _buildGenderDropdown(),
              _buildTextField(passwordController, '비밀번호', obscure: true),
              _buildTextField(confirmPasswordController, '비밀번호 확인', obscure: true),
              _buildTextField(introController, '자기소개', maxLines: 3),

              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('이용약관 및 개인정보 처리방침에 동의합니다. (필수)'),
                value: agreeTerms,
                activeColor: travelingPurple,
                onChanged: (val) => setState(() => agreeTerms = val ?? false),
              ),
              CheckboxListTile(
                title: const Text('여행 정보 수신에 동의합니다. (선택)'),
                value: agreeMarketing,
                activeColor: travelingPurple,
                onChanged: (val) => setState(() => agreeMarketing = val ?? false),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: travelingPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('회원가입', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  '이미 계정이 있으신가요? 로그인',
                  style: TextStyle(color: travelingPurple),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscure = false, TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return '$label을 입력해주세요';
          if (label == '비밀번호 확인' && value != passwordController.text) {
            return '비밀번호가 일치하지 않습니다';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _selectBirthday,
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: '생년월일',
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: birthday != null
                  ? DateFormat('yyyy-MM-dd').format(birthday!)
                  : '',
            ),
            validator: (value) {
              if (birthday == null) return '생년월일을 선택해주세요';
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: '성별',
          border: OutlineInputBorder(),
        ),
        value: gender,
        items: const [
          DropdownMenuItem(value: 'MALE', child: Text('남성')),
          DropdownMenuItem(value: 'FEMALE', child: Text('여성')),
          DropdownMenuItem(value: 'OTHER', child: Text('기타')),
        ],
        onChanged: (val) => setState(() => gender = val),
        validator: (val) => val == null ? '성별을 선택해주세요' : null,
      ),
    );
  }
}
