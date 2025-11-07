import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'article.dart';
import 'article_details.dart';
import 'main.dart';
import 'dart:convert';
import 'helpers/history_manager.dart';

// Display the history of read articles. This is the third tab in the main.dart file.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Article> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  // Load history from shared preferences into _history list
  Future<void> _loadHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? historyJson = prefs.getStringList('history');

    if (historyJson != null) {
      setState(() {
        _history = historyJson
            .map(
              (String articleJson) =>
                  Article.fromJson(json.decode(articleJson)),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _history.isEmpty
          ? const Center(
              child: const Text("You haven't read any articles yet!"),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final article = _history[index];
                return ListTile(
                  leading: article.imageUrl.isNotEmpty
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(
                            article.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.article),
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  subtitle: Text(article.title, maxLines: 1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailPage(article: article),
                      ),
                    );
                  },
                );
              },
            ),
      // Floating action button to clear history
      floatingActionButton: FloatingActionButton(
        // Once pressed, clear history and reload the history page
        onPressed: () async {
          await HistoryManager.clearHistory();
          setState(() {
            _history = [];
          });
          await _loadHistory();
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
