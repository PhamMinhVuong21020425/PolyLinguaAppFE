import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/favorite/favorite_controller.dart';
import 'package:poly_lingua_app/utils/calculate_read_time.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the home page
            Get.toNamed('/home');
          },
        ),
        title: const Text('Favorites'),
      ),
      body: controller.articleList.isEmpty
          ? const Center(
              child: Text('No favorites yet'),
            )
          : Obx(
              () => Center(
                child: ListView.builder(
                  itemCount: controller.articleList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle click event
                        Get.toNamed('/article',
                            arguments: controller.articleList[index]);
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
                                child: Image.network(
                                  controller.articleList[index].image,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              width: MediaQuery.of(context).size.width - 160,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.articleList[index].title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    controller.articleList[index].description ??
                                        '',
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
                                        controller.articleList[index]
                                                    .publishedAt.length <
                                                20
                                            ? controller
                                                .articleList[index].publishedAt
                                            : controller
                                                .articleList[index].publishedAt
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
                                            '${controller.articleList[index].language == 'en' ? calculateReadTimeEn(controller.articleList[index].content) : calculateReadTimeJa(controller.articleList[index].content)} mins',
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
            ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
