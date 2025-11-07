// import 'package:flutter/foundation.dart';

// Model class representing a news article

class Article {
  final String title;
  final String imageUrl;
  final String description;
  final String url;
  final String sourceName;
  final String content;
  final String author;

  Article({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.url,
    required this.sourceName,
    required this.content,
    required this.author,
  });

  // Convert article to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'urlToImage': imageUrl,
      'description': description,
      'url': url,
      'source': {'name': sourceName},
      'content': content,
      'author': author,
    };
  }

  // Create article from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      imageUrl: json['urlToImage'] ?? '',
      description: json['description'] ?? 'No description',
      url: json['url'] ?? 'Missing URL',
      sourceName: json['source'] != null && json['source']['name'] != null
          ? json['source']['name']
          : 'Unknown Source',
      content: json['content'] ?? 'Content unavailable in app. Please view online',
      author: json['author'] ?? 'No Author Listed'
    );
  }
}
