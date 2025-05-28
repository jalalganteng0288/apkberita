import 'package:flutter/material.dart';
// ignore: unused_import
import '../models/news_model.dart';

class DetailPage extends StatelessWidget {
  final NewsModel news;

  const DetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            news.urlToImage.isNotEmpty
                ? Image.network(news.urlToImage)
                // ignore: prefer_const_constructors
                : SizedBox.shrink(),
            const SizedBox(height: 16),
            Text(
              news.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(news.description),
          ],
        ),
      ),
    );
  }
}
