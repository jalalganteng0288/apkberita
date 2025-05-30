import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../utils/constants.dart';
// ignore: unused_import
import '../config/api_config.dart';

class NewsService {
  Future<List<NewsModel>> fetchNews({String category = 'general'}) async {
    final url = Uri.parse(
      '$baseUrl/top-headlines?country=id&category=$category&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List articles = body['articles'];
      return articles.map((json) {
        final news = NewsModel.fromJson(json);
        news.category = category;  // set category setelah buat objek
        return news;
      }).toList();
    } else {
      throw Exception('Gagal mengambil data berita');
    }
  }
}
