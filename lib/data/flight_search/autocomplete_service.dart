import 'package:dio/dio.dart';

class AutocompleteService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<Map<String, String>>> fetchSuggestions(String term) async {
    try {
      final response = await _dio.get(
        '/api/flights/autocomplete',
        queryParameters: {'term': term},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];

        return data.map<Map<String, String>>((item) {
          return {
            'label': item['detailedName'] ?? '',
            'iataCode': item['iataCode'] ?? '',
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ 자동완성 오류: $e');
      return [];
    }
  }
}
