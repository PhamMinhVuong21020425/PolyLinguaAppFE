class Article {
  final String title;
  final String? description;
  final String url;
  final String image;
  final DateTime publishedAt;
  final String content;

  Article({
    required this.title,
    this.description,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.content,
  });
}
