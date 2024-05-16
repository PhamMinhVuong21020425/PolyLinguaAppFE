class Flashcard {
  final String question;
  final String answer;
  final String language;
  bool star;

  Flashcard({
    required this.question,
    required this.answer,
    required this.language,
    this.star = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'language': language,
      'star': star,
    };
  }

  static Flashcard fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
      language: json['language'],
      star: json['star'] ?? false,
    );
  }
}
