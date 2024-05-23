import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_screen.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class StarVocabularyScreen extends GetView<FlashcardsController> {
  const StarVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      builder: (userController) {
        if (userController.user == null) {
          return const Center(child: Text('No user found. Please sign in.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Star Vocabulary'),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 22),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    // Add your action here, such as navigating to a new screen
                    // or showing a dialog to add a new vocabulary item
                  },
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView.builder(
                itemCount: controller.starVocabList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.currentIndex.value = index;
                      Get.to(const FlashcardsScreen(),
                          arguments: controller.starVocabList);
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
                                controller.starVocabList[index].question,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.toggleVocabularyStar(index);
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
