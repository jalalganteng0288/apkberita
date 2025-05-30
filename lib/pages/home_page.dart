// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/news_model.dart';
import '../services/news_service.dart';
import 'detail_page.dart';
import 'download_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
    'Ekonomi',
    'Teknologi',
    'Olahraga',
  ];

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadPages();
    _fetchNews();
  }

  void _loadPages() {
    _pages = [
      _buildHomePageContent(),
      const DownloadPage(),
      const NotificationPage(),
      const ProfilePage(),
    ];
  }

  Future<void> _fetchNews() async {
    try {
      final news = await _newsService.fetchNews();
      if (!mounted) return;
      setState(() {
        _newsList = news;
        _filteredNewsList = news;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
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

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterNews();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _filterNews();
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Kategori filter di sini
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return GestureDetector(
                  onTap: () => _onCategoryTap(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredNewsList.isEmpty
                  ? const Center(child: Text('Tidak ada data ditemukan.'))
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _filteredNewsList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final news = _filteredNewsList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(news: news),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(12)),
                                  child: Image.network(
                                    news.urlToImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image,
                                                size: 50),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          news.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          news.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
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
