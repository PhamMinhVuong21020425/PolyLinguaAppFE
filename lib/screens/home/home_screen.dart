import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/services/user_controller.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';
import 'package:poly_lingua_app/classes/article.dart';

import '../../utils/fetch_articles.dart';
import '../../utils/calculate_read_time.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.find<UserController>();
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(() {
      setState(() {
        // Rebuild the widget with the updated search text
      });
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<Article> filterArticles(List<Article> articles, String searchText) {
    return articles
        .where((article) =>
            article.title.toLowerCase().contains(searchText.toLowerCase()) ||
            article.url.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                  child: TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          searchTextController.clear();
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Article>>(
                    future: fetchArticlesFromJson(
                        userController.user!.language == 'en' ? true : false),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Article>? articles = snapshot.data;
                        List<Article> filteredArticles = filterArticles(
                          articles!,
                          searchTextController.text.trim(),
                        );
                        return Center(
                          child: ListView.builder(
                            itemCount: filteredArticles.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/article',
                                    arguments: filteredArticles[index],
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height: 160,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.green,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 160,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            filteredArticles[index].image,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                160,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredArticles[index].title,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              filteredArticles[index]
                                                      .description ??
                                                  '',
                                              maxLines: 3,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  filteredArticles[index]
                                                              .publishedAt
                                                              .length <
                                                          20
                                                      ? filteredArticles[index]
                                                          .publishedAt
                                                      : filteredArticles[index]
                                                          .publishedAt
                                                          .substring(0, 21),
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.timelapse,
                                                      size: 15,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      '${filteredArticles[index].language == 'en' ? calculateReadTimeEn(filteredArticles[index].content) : calculateReadTimeJa(filteredArticles[index].content)} mins',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade500,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
