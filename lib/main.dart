import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'article.dart';
import 'news_service.dart';
import 'article_details.dart';
import 'saved_articles.dart';
import 'history.dart';
import 'helpers/history_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter News App';
    return MaterialApp(
      title: appTitle,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.newspaper)),
                Tab(icon: Icon(Icons.bookmark)),
                Tab(icon: Icon(Icons.history)),
              ],
            ),
          ),
          body: const SafeArea(
            child: TabBarView(
              children: [NewsFeed(), SavedArticlesScreen(), HistoryScreen()],
            ),
          ),
        ),
      ),
    );
  }
}

// class NewsTabBar extends StatelessWidget {
//   const NewsTabBar({super.key});

//   @override
//   Widget build(BuildContext context) {}
// }

// News Feed Tab
class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // List of News Categories. Each uses a different category parameter when fetching articles. This is built in the news_service.dart file.
        children: [
          CategoryStoriesHorizontalList(title: 'Top Stories'),
          CategoryStoriesHorizontalList(
            title: 'Business',
            category: 'business',
          ),
          CategoryStoriesHorizontalList(title: 'Sports', category: 'sports'),
          CategoryStoriesHorizontalList(
            title: 'Technology',
            category: 'technology',
          ),
          CategoryStoriesHorizontalList(title: 'Health', category: 'health'),
          CategoryStoriesHorizontalList(
            title: 'Entertainment',
            category: 'entertainment',
          ),
          CategoryStoriesHorizontalList(title: 'Science', category: 'science'),
        ],
      ),
    );
  }
}

// Widget to display a horizonal list
class CategoryStoriesHorizontalList extends StatelessWidget {
  final String title;
  final String? category;

  const CategoryStoriesHorizontalList({
    super.key,
    required this.title,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 8),

        FutureBuilder<List<Article>>(
          future: NewsService.fetchArticles(category: category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200.0,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 200.0,
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(
                height: 200.0,
                child: Center(child: Text('No Articles Found')),
              );
            }

            final articles = snapshot.data!;

            // Container for list cards
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 200,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];

                  return GestureDetector(
                    onTap: () async {
                      await HistoryManager.saveArticle(article);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(article: article),
                        ),
                      );
                    },

                    // List Card
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            // populate image/placeholder
                            child: article.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      article.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 4),

                          // Populate title and source
                          Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.sourceName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
