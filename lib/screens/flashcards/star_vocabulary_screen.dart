import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_screen.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class StarVocabularyScreen extends GetView<FlashcardsController> {
  const StarVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    final languageController = TextEditingController();

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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                // Add a rounded rectangle border with a shadow
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(
                                  color: Colors
                                      .transparent, // Make the border color transparent
                                ),
                              ),
                              shadowColor: Colors
                                  .grey, // Set the color of the shadow to black
                              elevation: 8.0, // Add a shadow around the box
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Add New Vocabulary',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: questionController,
                                        decoration: const InputDecoration(
                                            labelText: 'Question'),
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return 'Please enter an vocabulary';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: answerController,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                            labelText: 'Answer'),
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return 'Please enter an answer';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: languageController,
                                        decoration: const InputDecoration(
                                          labelText: 'Language',
                                        ),
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return 'Please enter an answer';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  // Add a rounded rectangle border with a shadow
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  side: const BorderSide(
                                                    color: Colors
                                                        .transparent, // Make the border color transparent
                                                  ),
                                                ),
                                                title: const Text(
                                                    'Select Language'),
                                                content: SizedBox(
                                                  width: double.minPositive,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        ['EN', 'JA'].length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ListTile(
                                                        title: Text([
                                                          'EN',
                                                          'JA'
                                                        ][index]),
                                                        onTap: () {
                                                          languageController
                                                              .text = [
                                                            'EN',
                                                            'JA'
                                                          ][index];
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // Handle "Cancel" button press
                                              Navigator.of(context).pop();
                                              questionController.clear();
                                              answerController.clear();
                                              languageController.text = '';
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () {
                                              // Handle "Save" button press
                                              if (formKey.currentState!
                                                  .validate()) {
                                                Flashcard newVocab = Flashcard(
                                                  question:
                                                      questionController.text,
                                                  answer: answerController.text,
                                                  language: languageController
                                                      .text
                                                      .toLowerCase(),
                                                  star: true,
                                                );
                                                controller.addVocab(newVocab);
                                                Navigator.of(context).pop();
                                                questionController.clear();
                                                answerController.clear();
                                                languageController.text = '';
                                              }
                                            },
                                            child: const Text(
                                              'Save',
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
                      controller.currentVocab.value =
                          controller.starVocabList[index];

                      Get.to(const FlashcardsScreen(), arguments: {
                        "data": controller.starVocabList,
                        "type": "star"
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
