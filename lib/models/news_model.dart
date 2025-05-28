// ignore_for_file: prefer_typing_uninitialized_variables

class NewsModel {
  final String title;
  final String description;
  final String urlToImage;

  var category;

  NewsModel({
    required this.title,
    required this.description,
    required this.urlToImage,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'Tidak ada judul',
      description: json['description'] ?? 'Tidak ada deskripsi',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}
