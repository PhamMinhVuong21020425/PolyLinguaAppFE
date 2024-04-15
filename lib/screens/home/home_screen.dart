import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';
import 'package:poly_lingua_app/classes/article.dart';

import '../../utils/fetch_articles.dart';
import '../../utils/calculate_read_time.dart';
import '../../utils/format_time.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                child: TextField(
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
                        // Handle click event
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Article>>(
                  future: fetchArticlesFromJson(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Article>? articles = snapshot.data;
                      return Center(
                        child: ListView.builder(
                          itemCount: articles!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Handle click event
                                Get.toNamed('/article',
                                    arguments: articles[index]);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      //color: Colors.blue,
                                      height: 160,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          articles[index].image,
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
                                      width: MediaQuery.of(context).size.width -
                                          160,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index].title,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            articles[index].description ?? '',
                                            maxLines: 3,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                formatTime(articles[index]
                                                    .publishedAt
                                                    .toString()),
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
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
                                                    '${calculateReadTime(articles[index].content)} mins',
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade500),
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
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.white,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       IconButton(
        //         color: Colors.black,
        //         icon: const Icon(Icons.home),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         color: Colors.black,
        //         icon: const Icon(Icons.bookmark),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         color: Colors.black,
        //         icon: const Icon(Icons.favorite),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         color: Colors.black,
        //         icon: const Icon(Icons.settings),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
