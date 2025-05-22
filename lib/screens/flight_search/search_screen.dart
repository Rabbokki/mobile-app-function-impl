import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/flight_search/flight_search_service.dart';
import '../../../data/flight_search/flight_info_model.dart';
import '../../../data/flight_search/autocomplete_service.dart';
import 'result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FlightSearchService _flightService = FlightSearchService();
  final AutocompleteService _autocompleteService = AutocompleteService();

  String tripType = '왕복';
  String selectedDeparture = '';
  String selectedArrival = '';
  DateTime? departureDate;
  DateTime? returnDate;
  int passengers = 1;
  bool isLoading = false;

  List<Map<String, String>> departureSuggestions = [];
  List<Map<String, String>> arrivalSuggestions = [];

  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
        } else {
          returnDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _handleSearch() async {
    if (selectedDeparture.isEmpty || selectedArrival.isEmpty || departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('출발지, 도착지, 출발일을 입력해 주세요.')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final List<FlightInfo> results = await _flightService.searchFlights(
        origin: selectedDeparture,
        destination: selectedArrival,
        departureDate: _formatDate(departureDate),
        returnDate: tripType == '왕복' ? _formatDate(returnDate) : '',
        realTime: true,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            flightResults: results,
            initialPassengerCount: passengers,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 실패: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onDepartureChanged(String value) async {
    _departureController.text = value;
    setState(() => selectedDeparture = '');
    if (value.trim().isEmpty) {
      setState(() => departureSuggestions = []);
      return;
    }
    final results = await _autocompleteService.fetchSuggestions(value);
    setState(() => departureSuggestions = results);
  }

  void _onArrivalChanged(String value) async {
    _arrivalController.text = value;
    setState(() => selectedArrival = '');
    if (value.trim().isEmpty) {
      setState(() => arrivalSuggestions = []);
      return;
    }
    final results = await _autocompleteService.fetchSuggestions(value);
    setState(() => arrivalSuggestions = results);
  }

  void _selectDeparture(Map<String, String> item) {
    _departureController.text = '${item['label']}';
    selectedDeparture = item['iataCode']!;
    setState(() => departureSuggestions = []);
  }

  void _selectArrival(Map<String, String> item) {
    _arrivalController.text = '${item['label']}';
    selectedArrival = item['iataCode']!;
    setState(() => arrivalSuggestions = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('항공권 검색'),
        centerTitle: true,
        backgroundColor: const Color(0xFFA78BFA),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: ['왕복', '편도'].map((type) {
                return Row(
                  children: [
                    Radio(
                      value: type,
                      groupValue: tripType,
                      onChanged: (value) {
                        setState(() => tripType = value!);
                      },
                    ),
                    Text(type),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _departureController,
              decoration: const InputDecoration(
                labelText: '출발지 (도시명 또는 IATA)',
                border: OutlineInputBorder(),
              ),
              onChanged: _onDepartureChanged,
            ),
            ...departureSuggestions.map((item) => ListTile(
              title: Text(item['label'] ?? ''),
              onTap: () => _selectDeparture(item),
            )),
            const SizedBox(height: 12),

            TextField(
              controller: _arrivalController,
              decoration: const InputDecoration(
                labelText: '도착지 (도시명 또는 IATA)',
                border: OutlineInputBorder(),
              ),
              onChanged: _onArrivalChanged,
            ),
            ...arrivalSuggestions.map((item) => ListTile(
              title: Text(item['label'] ?? ''),
              onTap: () => _selectArrival(item),
            )),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '출발일',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        departureDate == null ? '날짜 선택' : _formatDate(departureDate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (tripType == '왕복')
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '귀국일',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          returnDate == null ? '날짜 선택' : _formatDate(returnDate),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
              value: passengers,
              items: List.generate(9, (index) => index + 1)
                  .map((num) => DropdownMenuItem(value: num, child: Text('$num명')))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => passengers = value);
              },
              decoration: const InputDecoration(
                labelText: '탑승객 수',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA78BFA), // 💜 보라색 버튼
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('검색', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
