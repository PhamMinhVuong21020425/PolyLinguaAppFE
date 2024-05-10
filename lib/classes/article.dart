class Article {
  final String title;
  final String? description;
  final String url;
  final String image;
  final String publishedAt;
  final String content;
  final String language;
  bool isFavorite;

  Article({
    required this.title,
    this.description,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.content,
    required this.language,
    this.isFavorite = false,
  });
}
