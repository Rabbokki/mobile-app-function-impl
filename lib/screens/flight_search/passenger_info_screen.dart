import 'package:flutter/material.dart';

class PassengerInfoScreen extends StatefulWidget {
  const PassengerInfoScreen({super.key});

  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> passengers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final flight = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int passengerCount = flight['passengerCount'] ?? 1;

    if (passengers.length != passengerCount) {
      passengers = List.generate(passengerCount, (_) => {
        'firstName': '',
        'lastName': '',
        'birthDate': '',
        'passportNumber': '',
        'nationality': '',
        'gender': '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final flight = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int passengerCount = flight['passengerCount'] ?? 1;

    return Scaffold(
      appBar: AppBar(title: Text('탑승객 정보 입력 (${passengerCount}명)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('항공사: ${flight['airline']} (${flight['flightNumber']})'),
              Text('좌석: ${flight['selectedSeats'].join(', ')}'),
              const Divider(height: 32),

              for (int i = 0; i < passengerCount; i++) ...[
                Text('🧍 탑승객 ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),

                TextFormField(
                  decoration: const InputDecoration(labelText: '이름 (영문)', hintText: '예: GILDONG'),
                  onChanged: (val) => passengers[i]['firstName'] = val,
                  validator: (val) => val!.isEmpty ? '이름을 입력해주세요.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '성 (영문)', hintText: '예: HONG'),
                  onChanged: (val) => passengers[i]['lastName'] = val,
                  validator: (val) => val!.isEmpty ? '성을 입력해주세요.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '생년월일 (예: 2000-12-31)'),
                  onChanged: (val) => passengers[i]['birthDate'] = val,
                  validator: (val) => val!.isEmpty ? '생년월일을 입력해주세요.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '여권번호'),
                  onChanged: (val) => passengers[i]['passportNumber'] = val,
                  validator: (val) => val!.isEmpty ? '여권번호를 입력해주세요.' : null,
                ),
                DropdownButtonFormField<String>(
                  value: passengers[i]['nationality']!.isNotEmpty ? passengers[i]['nationality'] : null,
                  decoration: const InputDecoration(labelText: '국적'),
                  items: ['대한민국', '일본', '미국', '영국','기타'].map((nation) {
                    return DropdownMenuItem(value: nation, child: Text(nation));
                  }).toList(),
                  onChanged: (val) => setState(() => passengers[i]['nationality'] = val!),
                  validator: (val) => val == null ? '국적을 선택해주세요.' : null,
                ),
                DropdownButtonFormField<String>(
                  value: passengers[i]['gender']!.isNotEmpty ? passengers[i]['gender'] : null,
                  decoration: const InputDecoration(labelText: '성별'),
                  items: ['남성', '여성'].map((g) {
                    return DropdownMenuItem(value: g, child: Text(g));
                  }).toList(),
                  onChanged: (val) => setState(() => passengers[i]['gender'] = val!),
                  validator: (val) => val == null ? '성별을 선택해주세요.' : null,
                ),
                const Divider(height: 32),
              ],

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(
                      context,
                      '/payment',
                      arguments: {
                        ...flight,
                        'passengers': passengers,
                      },
                    );
                  }
                },
                child: const Text('다음: 결제'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
