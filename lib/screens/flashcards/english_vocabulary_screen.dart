import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_screen.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class EnglishVocabularyScreen extends GetView<FlashcardsController> {
  const EnglishVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      builder: (userController) {
        if (userController.user == null) {
          return const Center(child: Text('No user found. Please sign in.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('English Vocabulary'),
          ),
          body: Stack(
            children: [
              ListView.builder(
                itemCount: controller.englishVocabList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.currentIndex.value = index;
                      controller.currentVocab.value =
                          controller.englishVocabList[index];
                      Get.to(const FlashcardsScreen(), arguments: {
                        "data": controller.englishVocabList,
                        "type": "english"
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.englishVocabList[index].question,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.toggleEnglishVocabularyStar(index);
                              },
                              icon: Icon(
                                Icons.star,
                                color: controller.englishVocabList[index].star
                                    ? const Color.fromARGB(255, 251, 192, 45)
                                    : Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.removeEnglishVocabulary(index);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
