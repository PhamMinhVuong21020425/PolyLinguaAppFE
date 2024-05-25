class Article {
  final String title;
  final String? description;
  final String url;
  final String image;
  final String publishedAt;
  final String content;
  final String language;

  const Article({
    required this.title,
    required this.description,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.content,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'image': image,
      'publishedAt': publishedAt,
      'content': content,
      'language': language,
    };
  }

  static Article fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      image: json['image'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      language: json['language'],
    );
  }
}
