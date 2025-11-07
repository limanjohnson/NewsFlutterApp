import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'article.dart';
import 'article_details.dart';
import 'dart:convert';
import 'helpers/history_manager.dart';

/// Screen to display saved articles
/// Allows users to view, access, and remove articles that have been saved for later reading.
/// 
/// This is the second tab in the main.dart file.
/// 
/// This screen gets the saved articles from SharedPreferences and displays them in a list.

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  List<Article> _savedArticles = [];


  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  // Function to load saved articles from SharedPreferences
  Future<void> _loadSavedArticles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedArticlesJson = prefs.getStringList('saved_articles');

    if (savedArticlesJson != null) {
      setState(() {
        _savedArticles = savedArticlesJson
        .map((String articleJson) =>
          Article.fromJson(json.decode(articleJson)))
          .toList();
      });
    }
  }

  // Function to remove article from the saved list
  Future<void> _removeArticle(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedArticlesJson = prefs.getStringList('saved_articles');

    if (savedArticlesJson != null) {
      savedArticlesJson.removeAt(index);
      await prefs.setStringList('saved_articles', savedArticlesJson);
    
    setState(() {
      _savedArticles.removeAt(index);
    });
    }
  }
  
  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
      ),
      body: _savedArticles.isEmpty
          ? const Center(
            child: Text('You have not saved any articles yet.'),
          )
          : ListView.builder(
            itemCount: _savedArticles.length,
            itemBuilder: (context, index) {
              final article = _savedArticles[index];
              return Dismissible(
                key: Key(article.url),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right:20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _removeArticle(index),
                child: ListTile(
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
                      subtitle: Text(article.sourceName, maxLines: 1,),
                      onTap: () async {
                        await HistoryManager.saveArticle(article);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:(context) => 
                            ArticleDetailPage(article: article),
                          ),
                        );
                      },
                    ),
                  );
                }
              ),
    );
  }
}