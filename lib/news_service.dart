import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';

class NewsService {
  static const String _apiKey = '0ec410038bd440d8afcf8d6a98beb13d';

  /// Fetch top headlines for country=us. If [category] is provided, it will
  /// fetch headlines for that category (e.g. 'business', 'technology').
  ///
  /// Returns a list of [Article]. Throws an [Exception] on non-200 responses.
  static Future<List<Article>> fetchArticles({String? category}) async {
    final base = 'https://newsapi.org/v2/top-headlines?country=us';
    final categoryQuery = (category != null && category.isNotEmpty) ? '&category=$category' : '';
    final url = '$base$categoryQuery&apiKey=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}