import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/article.dart';
import 'package:poly_lingua_app/utils/calculate_read_time.dart';
import 'package:poly_lingua_app/utils/check_image_network.dart';

class RecommendWidget extends StatelessWidget {
  const RecommendWidget({super.key, required this.recommendArticles});
  final List<Article> recommendArticles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, left: 16),
          child: Text(
            'Recommendation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: recommendArticles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle click event
                  Get.toNamed(
                    '/article',
                    arguments: recommendArticles[index],
                    preventDuplicates: false,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.pinkAccent,
                        width: 1.5,
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
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: checkImageNetwork(
                            recommendArticles[index].image,
                            context,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recommendArticles[index].title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              recommendArticles[index].description ?? '',
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  recommendArticles[index].publishedAt.length <
                                          20
                                      ? recommendArticles[index].publishedAt
                                      : recommendArticles[index]
                                          .publishedAt
                                          .substring(0, 21),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade400),
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
                                      '${recommendArticles[index].language == 'en' ? calculateReadTimeEn(recommendArticles[index].content) : calculateReadTimeJa(recommendArticles[index].content)} mins',
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        color: Colors.grey.shade500,
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
        ),
      ],
    );
  }
}
