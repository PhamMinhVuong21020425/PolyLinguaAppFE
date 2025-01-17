import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/classes/word_data.dart';
import 'package:poly_lingua_app/screens/article/article_controller.dart';
import 'package:poly_lingua_app/screens/article/classifier_widget.dart';
import 'package:poly_lingua_app/screens/article/comment_widget.dart';
import 'package:poly_lingua_app/screens/article/recommend_widget.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/services/bm25_okapi.dart';
import 'package:poly_lingua_app/services/user_controller.dart';
import 'package:poly_lingua_app/utils/calculate_read_time.dart';
import 'package:poly_lingua_app/utils/fetch_articles.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:poly_lingua_app/utils/stem_word.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ArticleScreen extends StatefulWidget {
  final Database database;
  const ArticleScreen({super.key, required this.database});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool renderSummary = false;
  bool isFavorite = false;
  ScrollController controller = ScrollController();
  final Article article = Get.arguments;
  final UserController userController = Get.find<UserController>();
  final flashcardsController = Get.put(FlashcardsController());
  final articleController = Get.find<ArticleController>();
  final FlutterTts flutterTts = FlutterTts();
  List<Article> recommendArticles = [];
  int views = 0;

  @override
  void initState() {
    super.initState();
    updateViews().then((value) => {});
    isFavorite = userController.user?.articles
            ?.any((element) => element.title == article.title) ??
        false;

    articleController
        .analyzeContent(article.content, article.language)
        .then((value) => setState(() {}))
        .catchError((e) => print('Failed to analyze content: $e'));

    articleController.fetchSummary(article.content, article.language, context);

    fetchRecommendArticles().then((value) => {
          setState(() {
            recommendArticles = value;
          })
        });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _pronounceWord(String word, String language) async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setPitch(1.2); // Higher frequency (pitch) of the voice
    await flutterTts.setLanguage(language);
    await flutterTts.speak(word);
  }

  Future<void> updateViews() async {
    bool isEnglish = userController.user!.language == 'en' ? true : false;
    final data = await readLocalFile(isEnglish);
    int pos = data.indexWhere((element) => element['title'] == article.title);

    if (pos == -1) {
      data.insert(0, article.toJson());
      pos = 0;
    }

    data[pos]['views'] =
        data[pos]['views'] != null ? data[pos]['views'] + 1 : 1;

    setState(() {
      views = data[pos]['views'];
    });

    await writeJsonFile(data, isEnglish);
    print('Updated: ${data[pos]['title']} with views: ${data[pos]['views']}');
  }

  Future<List<Article>> fetchRecommendArticles() async {
    bool isEnglish = (article.language == 'en');
    List<Article> articles = await fetchArticlesFromJson(isEnglish);

    if (!isEnglish) {
      articles.shuffle(Random());
      List<Article> japanArticles = articles.sublist(0, 4);
      return japanArticles;
    }

    List<String> query = article.content.toLowerCase().trim().split(' ');
    List<String> corpus =
        articles.map((article) => article.content.toLowerCase()).toList();

    BM25Okapi bm25 = BM25Okapi(corpus);
    List<Article> bm25Articles = bm25.getTopN(query, articles, 5);

    return bm25Articles
        .where((element) => element.title != article.title)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('News Article'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'favorite') {
                setState(() {
                  isFavorite = !isFavorite;
                  Get.find<FavoriteController>()
                      .toggleFavorite(article, isFavorite);
                });
              } else if (value == 'summarize') {
                setState(() {
                  renderSummary = true;
                });
                controller.animateTo(
                  controller.position.maxScrollExtent - 400,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'favorite',
                  child: Row(
                    children: [
                      isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.black,
                            ),
                      const SizedBox(width: 10),
                      const Text('Favorite'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'summarize',
                  child: Row(
                    children: [
                      Icon(
                        Icons.summarize_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text('Summarize'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                // Handle 404 error and render default image
                if (error is NetworkImageLoadException) {
                  return Image.asset(
                    'assets/images/asahi.jpg',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  );
                }
                // Handle other errors
                return Container();
              },
              loadingBuilder: (context, child, loadingProgress) {
                // Handle loading state if needed
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: Image.asset(
                    'assets/images/news.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.publishedAt,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.grey,
                            ),
                            Text(
                              ' $views views',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Read Time: ${article.language == 'en' ? calculateReadTimeEn(article.content) : calculateReadTimeJa(article.content)} minutes',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ClassifierButton(article: article),
                  const SizedBox(height: 12),
                  articleController.wordDataObs.isEmpty
                      ? Text(
                          article.content,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        )
                      : SelectableText.rich(
                          textAlign: TextAlign.justify,
                          TextSpan(
                            children: parseContent(
                              articleController.wordDataObs,
                              article.language,
                              context,
                            ),
                          ),
                        ),
                  if (renderSummary == true) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          articleController.summaryObs.value.trim(),
                          textAlign: TextAlign.justify,
                          textStyle: const TextStyle(fontSize: 16),
                          speed: const Duration(milliseconds: 20),
                        ),
                      ],
                      totalRepeatCount: 1,
                      onNext: (index, isLast) {
                        controller.animateTo(
                          controller.position.maxScrollExtent - 400,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  ArticleCommentSection(
                    articleTitle: article.title,
                  ),
                ],
              ),
            ),
            RecommendWidget(recommendArticles: recommendArticles),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<InlineSpan> parseContent(
    List<WordData> wordData,
    String language,
    BuildContext context,
  ) {
    final List<InlineSpan> spans = [];

    for (final word in wordData) {
      if (word.word.endsWith('\n')) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }
      spans.add(
        TextSpan(
          text: '${word.word} ',
          style: TextStyle(
            color: getColorForPart(word.pos),
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showWordInfo(word, language, context);
            },
        ),
      );
    }

    return spans;
  }

  Color getColorForPart(String part) {
    switch (part) {
      case 'NOUN' || '名詞':
        return Colors.green;
      case 'VERB' || '動詞':
        return Colors.red;
      case 'ADJ' || '形容詞':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  void showWordInfo(WordData wordData, String language, BuildContext context) {
    bool isStar = userController.user?.vocabularies?.any(
            (element) => element.question == wordData.word && element.star) ??
        false;

    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set the background color to white
          shape: RoundedRectangleBorder(
            // Add a rounded rectangle border with a shadow
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.transparent, // Make the border color transparent
            ),
          ),
          shadowColor: Colors.grey, // Set the color of the shadow to black
          elevation: 8.0, // Add a shadow around the box
          scrollable: true,
          actionsAlignment: MainAxisAlignment.end,
          title: Row(
            children: [
              Text(
                wordData.word,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.volume_up_rounded),
                  onPressed: () {
                    if (language == "en") {
                      _pronounceWord(wordData.word, 'en-US');
                    } // for English
                    if (language == "ja") {
                      _pronounceWord(wordData.word, 'ja-JP');
                    } // for Japanese
                  }),
              IconButton(
                icon: GetX<UserController>(builder: (userController) {
                  final user = userController.user;
                  if (user == null) {
                    return const Center(
                        child: Text('No user found. Please sign in.'));
                  }
                  return Icon(
                    isStar ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isStar ? Colors.amber : Colors.black,
                  );
                }),
                onPressed: () async {
                  Map<String, String> transWord =
                      await getInfo(wordData.word, wordData.pos, language);
                  Flashcard vocabulary = Flashcard(
                    question: wordData.word,
                    answer:
                        '${transWord['pronounce']!}\n${transWord['definition']!}',
                    language: language,
                    star: true,
                  );

                  isStar = !isStar;
                  flashcardsController.toggleStar(vocabulary, isStar);
                },
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Type: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Time News Roman',
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: wordData.pos,
                      style: const TextStyle(
                        fontFamily: 'Time News Roman',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, String>>(
                future: getInfo(wordData.word, wordData.pos, language),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Pronunciation: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Time News Roman',
                                  ),
                                ),
                                TextSpan(
                                  text: snapshot.data?['pronounce'] == 'N/A'
                                      ? 'N/A'
                                      : '\n${snapshot.data?['pronounce']}',
                                  style: const TextStyle(
                                    fontFamily: 'Time News Roman',
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Definition: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Time News Roman',
                                  ),
                                ),
                                TextSpan(
                                  text: snapshot.data?['definition'] == 'N/A'
                                      ? 'N/A'
                                      : '\n${snapshot.data?['definition']}',
                                  style: const TextStyle(
                                    fontFamily: 'Time News Roman',
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, String>> getInfo(
      String word, String pos, String language) async {
    // Query DB for wordData
    String sql = 'SELECT * FROM english_words WHERE word = ?';
    if (language == 'ja') {
      sql = 'SELECT * FROM japanese_words WHERE word = ?';
    } else {
      if (pos == 'NOUN') word = singularize(word);
      if (pos == 'VERB') word = stemEnglishWord(word);
    }

    List<Map<String, Object?>> result =
        await widget.database.rawQuery(sql, [word]);

    if (result.isEmpty) {
      word = '${word}e';
      result = await widget.database.rawQuery(sql, [word]);
    }

    Map<String, Object?>? firstRow = result.isNotEmpty ? result.first : null;
    String pronounce = firstRow?['pronounce'] as String? ?? 'N/A';
    String definition = firstRow?['definition'] as String? ?? 'N/A';
    return {
      'pronounce': pronounce,
      'definition': definition.replaceAll('\\n', '\n'),
    };
  }
}
