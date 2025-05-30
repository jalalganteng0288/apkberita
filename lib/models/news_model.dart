class NewsModel {
  final String title;
  final String description;
  final String urlToImage;
  String category;  // harus non-final supaya bisa diubah

  NewsModel({
    required this.title,
    required this.description,
    required this.urlToImage,
    this.category = 'general',
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      category: 'general',  // default, nanti di-set ulang di service
    );
  }
}
