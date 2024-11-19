import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/app/models/news_model.dart';

class ApiService {
  // Berita dari kumparan
  final String baseUrl = 'https://berita-indo-api-next.vercel.app/api/kumparan-news';

  Future<List<KumparanNews>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        return data.map((article) => KumparanNews.fromJson(article)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
