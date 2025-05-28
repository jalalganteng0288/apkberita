// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/news_model.dart';
import '../services/news_service.dart';
import 'detail_page.dart';
import 'login_page.dart';
import 'download_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String _username = '';
  List<NewsModel> _newsList = [];
  List<NewsModel> _filteredNewsList = [];
  bool _isLoading = true;

  final NewsService _newsService = NewsService();

  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Nasional',
    'Internasional',
    'Sport',
    'Viral',
    'Terkini',
  ];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchNews();

    _pages.add(_buildHomePageContent());
    _pages.add(const DownloadPage());
    _pages.add(const NotificationPage());
    _pages.add(const ProfilePage());
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  Future<void> _fetchNews() async {
    try {
      final news = await _newsService.fetchNews();
      setState(() {
        _newsList = news;
        _filteredNewsList = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat berita: $e')),
      );
    }
  }

  Future<void> _fetchNewsByCategory(String category) async {
    setState(() => _isLoading = true);

    try {
      final news = await _newsService.fetchNews(category: category);
      setState(() {
        _newsList = news;
        _filteredNewsList = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat berita: $e')),
      );
    }
  }

  void _filterNews() {
    List<NewsModel> filtered = _newsList;

    if (_selectedCategory != 'Semua') {
      filtered = filtered
          .where((news) =>
              news.category.toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((news) =>
              news.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredNewsList = filtered;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _onCategoryTap(String category) {
    setState(() => _selectedCategory = category);
    if (category == 'Semua') {
      _fetchNews();
    } else {
      _fetchNewsByCategory(category);
    }
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _filterNews();
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildHomePageContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, $_username!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari berita...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return GestureDetector(
                  onTap: () => _onCategoryTap(category),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Daftar Berita:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNewsList.isEmpty
                    ? const Center(child: Text('Tidak ada berita'))
                    : ListView.builder(
                        itemCount: _filteredNewsList.length,
                        itemBuilder: (context, index) {
                          final news = _filteredNewsList[index];
                          return ListTile(
                            leading: news.urlToImage.isNotEmpty
                                ? Image.network(
                                    news.urlToImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(news.title),
                            subtitle: Text(news.description),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(news: news),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kabar Berita'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Download',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
