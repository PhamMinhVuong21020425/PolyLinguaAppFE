import 'package:flutter/material.dart';
import 'package:poly_lingua_app/models/article.dart';

import '../../utils/fetch_articles.dart';
import '../../utils/calculate_read_time.dart';
import '../../utils/format_time.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                top: 30.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                  return ListView.builder(
                    itemCount: articles!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle click event
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          decoration: const BoxDecoration(
                            color: Colors.white,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        articles[index].image,
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${calculateReadingTime(articles[index].content)} min',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey.shade400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: MediaQuery.of(context).size.width - 170,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      articles[index].title,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      articles[index].description ?? '',
                                      maxLines: 3,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      formatTime(articles[index]
                                          .publishedAt
                                          .toString()),
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.bookmark),
              onPressed: () {},
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
