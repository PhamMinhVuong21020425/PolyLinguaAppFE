import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/classes/word_data.dart';
import 'package:poly_lingua_app/screens/article/comment_widget.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/services/user_controller.dart';
import 'package:poly_lingua_app/utils/calculate_read_time.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_lingua_app/utils/stem_word.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ArticleScreen extends StatefulWidget {
  final Database database;
  const ArticleScreen({super.key, required this.database});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  String? _summary;
  bool renderSummary = false;
  bool isFetched = false;
  bool isFavorite = false;
  ScrollController controller = ScrollController();
  final Article article = Get.arguments;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();
  final flashcardsController = Get.put(FlashcardsController());
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    isFavorite = userController.user?.articles
            ?.any((element) => element.title == article.title) ??
        false;
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

  @override
  Widget build(BuildContext context) {
    print('IS FETCH $isFetched');

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
                  controller.position.maxScrollExtent + 100,
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
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
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
                        article.publishedAt.length < 25
                            ? article.publishedAt
                            : article.publishedAt.substring(0, 24),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          'Read Time: ${article.language == 'en' ? calculateReadTimeEn(article.content) : calculateReadTimeJa(article.content)} mins',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<WordData>>(
                    future: analyzeContent(article.content, article.language),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SelectableText.rich(
                          TextSpan(
                            children: parseContent(
                                snapshot.data!, article.language, context),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // handle error
                        // return Text('Error: ${snapshot.error}\n');
                        return Text(article.content,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 16));
                      } else {
                        // return const Padding(
                        //   padding: EdgeInsets.only(top: 30.0),
                        //   child: Center(
                        //       child: CircularProgressIndicator(
                        //     color: Colors.green,
                        //     strokeWidth: 3.0,
                        //   )),
                        // );

                        return Text(
                          article.content,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        );
                      }
                    },
                  ),
                  if (isFetched == false) ...[
                    FutureBuilder<void>(
                      future: _fetchSummary(
                          article.content, article.language, context),
                      builder: (context, snapshot) {
                        return const Text("");
                      },
                    ),
                  ],
                  if (_summary != null && renderSummary == true) ...[
                    const SizedBox(height: 16),
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
                          _summary!,
                          textStyle: const TextStyle(fontSize: 16),
                          speed: const Duration(milliseconds: 20),
                        ),
                      ],
                      totalRepeatCount: 1,
                      onNext: (index, isLast) {
                        controller.animateTo(
                          controller.position.maxScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ],
                  ArticleCommentSection(
                    articleTitle: article.title,
                  ),
                ],
              ),
            ),
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
      List<WordData> wordData, String language, BuildContext context) {
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
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                    const TextSpan(
                      text: 'Type: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Time News Roman',
                      ),
                    ),
                    TextSpan(
                      text: wordData.pos,
                      style: const TextStyle(
                        fontFamily: 'Time News Roman',
                      ),
                    ),
                  ])),
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

  Future<String> summarizeContent(String content, String language) async {
    final snapshot = await _firestore.collection("servers").get();
    final docs = snapshot.docs;
    final server = docs[0].data() as Map;
    print(server['summarization_api']);

    final url = Uri.parse('${server['summarization_api']}/api/v1/summarize');
    final body = jsonEncode({"query": content, "language": language});

    try {
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;
        final summary = data['result'] as String;

        return summary;
      } else {
        throw Exception('Failed to summarize content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to summarize content: $e');
    }

    // return 'This is a summary of the content, which is a brief overview of the main points, without going into too much detail, but enough to give you an idea of what the content is about, so you can decide if you want to read the full article or not, based on this summary.';
  }

  Future<void> _fetchSummary(
      String content, String language, BuildContext context) async {
    try {
      print('Fetching summary...');
      final summary = await summarizeContent(content, language);
      _summary = summary;
      isFetched = true;
      print('Done fetching summary!');
    } catch (e) {
      if (!context.mounted) return;
      print('Failed to fetch summary: $e');
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('Error'),
      //     content: Text('Failed to fetch summary: $e'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  Future<List<WordData>> analyzeContent(String content, String language) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/v1/analyze');
    final body = jsonEncode({"text": content, "language": language});

    try {
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final wordData = data
            .map((item) => WordData(
                  word: item['word'],
                  pos: item['pos'],
                  definition: item['definition'],
                ))
            .toList();

        return wordData;
      } else {
        throw Exception('Failed to analyze content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze content: $e');
    }
  }
}
