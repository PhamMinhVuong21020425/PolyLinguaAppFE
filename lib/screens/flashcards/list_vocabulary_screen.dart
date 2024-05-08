import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';

class FlashcardVocabularyScreen extends GetView<FlashcardsController> {
  const FlashcardVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vocabulary'),
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: controller.vocabList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/home');
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
                            controller.vocabList[index],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.toggleFavorite(index);
                            },
                            icon: Obx(
                              () => Icon(
                                Icons.star,
                                color: controller.isFavorite[index]
                                    ? const Color.fromARGB(255, 251, 192, 45)
                                    : Colors.grey,
                              ),
                            )),
                        IconButton(
                          onPressed: () {
                            controller.removeVocab(index);
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
        ));
  }
}
