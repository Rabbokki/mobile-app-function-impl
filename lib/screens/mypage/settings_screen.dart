import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Password fields
  bool _showPassword = false;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isProcessingPassword = false;

  // Notification toggles
  bool _emailNotification = true;
  bool _socialNotification = true;
  bool _updatesNotification = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // TODO: load initial notification settings from backend or prefs
  }

  @override
  void dispose() {
    _tabController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handlePasswordChange() async {
    final current = _currentPasswordController.text;
    final next = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      _showSnack('모든 비밀번호 필드를 입력해주세요.');
      return;
    }
    if (next != confirm) {
      _showSnack('새 비밀번호와 확인이 일치하지 않습니다.');
      return;
    }

    setState(() => _isProcessingPassword = true);
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) {
      setState(() => _isProcessingPassword = false);
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts/password');
    try {
      final resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access_Token': accessToken,
          'Refresh_Token': refreshToken ?? ''
        },
        body: jsonEncode({
          'currentPassword': current,
          'newPassword': next,
        }),
      );

      if (resp.statusCode == 200) {
        _showSnack('비밀번호가 성공적으로 변경되었습니다!');
        prefs.remove('accessToken');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
        });
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        final data = jsonDecode(resp.body);
        final msg = data['message'] ?? '비밀번호 변경 중 오류가 발생했습니다.';
        _showSnack(msg);
      }
    } catch (e) {
      _showSnack('네트워크 오류: \$e');
    } finally {
      setState(() => _isProcessingPassword = false);
    }
  }

  Future<void> _handleDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken == null) return;

    final url = Uri.parse('http://10.0.2.2:8080/api/accounts');
    try {
      final resp = await http.delete(
        url,
        headers: {
          'Access_Token': accessToken,
          'Refresh_Token': refreshToken ?? ''
        },
      );
      if (resp.statusCode == 200) {
        _showSnack('계정이 성공적으로 삭제되었습니다!');
        prefs.clear();
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
        });
      } else {
        final data = jsonDecode(resp.body);
        final msg = data['message'] ?? '계정 삭제 중 오류가 발생했습니다.';
        _showSnack(msg);
      }
    } catch (e) {
      _showSnack('네트워크 오류: \$e');
    }
  }

  Future<void> _handleSaveNotifications() async {
    // TODO: send notification prefs to backend
    _showSnack('설정 저장됨');
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushNamed(context, '/mypage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '계정'), Tab(text: '알림')],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
      // Account Tab
      SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('비밀번호 변경', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _currentPasswordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: '현재 비밀번호',
              suffixIcon: IconButton(
                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPasswordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: '새 비밀번호',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: '비밀번호 확인',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isProcessingPassword ? null : _handlePasswordChange,
            icon: const Icon(Icons.lock),
            label: const Text('비밀번호 변경'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const Divider(height: 32),
          const Text('계정 삭제', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            '삭제 시 모든 데이터가 영구적으로 제거됩니다. 이 작업은 되돌릴 수 없습니다.',
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _handleDeleteAccount,
            child: const Text('계정 삭제', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    ),

    // Notifications Tab
    SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
    children: [
    SwitchListTile(
    title: const Text('이메일 알림'),
    subtitle: const Text('중요 알림을 이메일로 받습니다.'),
    value: _emailNotification,
    onChanged: (v) => setState(() => _emailNotification = v),
    ),
    const Divider(),
    SwitchListTile(
    title: const Text('소셜 알림'),
    subtitle: const Text('친
