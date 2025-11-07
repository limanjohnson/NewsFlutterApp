import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../article.dart';

// Helper class to manage history of read articles
class HistoryManager {
  static Future<void> saveArticle(Article article) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? historyJson = prefs.getStringList('history') ?? [];

    List<Article> history = historyJson
        .map((jsonStr) => Article.fromJson(json.decode(jsonStr)))
        .toList();

        // Check for duplicates
        bool alreadyExists = history.any((a) => a.url == article.url);

        // If not a duplicate, add to history at beginning of list
        if (!alreadyExists) {
          history.insert(0, article);

          final updatedJson =
              history.map((a) => json.encode(a.toJson())).toList();

              await prefs.setStringList('history', updatedJson);
        }
  } 

  // This function clears the entire read history
  static Future<void> clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
  }
}