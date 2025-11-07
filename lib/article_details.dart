import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'article.dart';
import 'dart:convert';

/// Detailed view for a single article
///
/// Displays article and provides options to save for later reading or to open to full article online.

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  Future<void> _saveArticle(Article article) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedArticles = prefs.getStringList('saved_articles') ?? [];

    savedArticles.add(jsonEncode(article.toJson()));
    await prefs.setStringList('saved_articles', savedArticles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(article.imageUrl),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('By: ${article.author}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(article.sourceName, style: const TextStyle(fontSize: 10)),
            const SizedBox(height: 8),
            if (article.description != null) Text(article.description),
            const SizedBox(height: 20),
            // if (article.content != null)
            //   Padding(
            //     padding: const EdgeInsets.only(bottom: 16),
            //     child: Text(
            //       article.content!.replaceAll(
            //         RegExp(r'\[\+\d+ chars\]'),
            //         '...',
            //       ),
            //       style: const TextStyle(fontSize: 16, height: 1.4),
            //     ),
            //   ),
            // const SizedBox(),

            /// These buttons allow:
            /// 1. Opening the full article in a browser
            /// 2. Saving the article for later reading. This uses SharedPreferences to store the article locally.
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(article.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not open article link, contact developer',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Read Full Article'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveArticle(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Article saved for later'),
                    ),
                  );
                },
                child: const Text('Save For later'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
