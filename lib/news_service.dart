import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';

class NewsService {
  static const String _apiKey = '0ec410038bd440d8afcf8d6a98beb13d';
  static const String _topStoriesUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=0ec410038bd440d8afcf8d6a98beb13d';

  static const String _businessUrl = 'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=0ec410038bd440d8afcf8d6a98beb13d';

  static Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(_topStoriesUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}