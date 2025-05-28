import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  List<NewsModel> _newsList = [];
  bool _isLoading = false;
  String? _error;

  List<NewsModel> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _newsList = await _newsService.fetchNews(category: 'mancanegara');
      _error = null;
    } catch (e) {
      _error = e.toString();
      _newsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
