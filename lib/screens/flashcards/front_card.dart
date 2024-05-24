import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/utils/pronounce_word.dart';

class FrontCard extends GetView<FlashcardsController> {
  const FrontCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    controller.currentVocab.value.question,
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.volume_up_outlined),
                    iconSize: 30,
                    onPressed: () {
                      if (controller.currentVocab.value.language == "en") {
                        pronounceWord(
                            controller.currentVocab.value.question, 'en-US');
                      } // for English
                      if (controller.currentVocab.value.language == "ja") {
                        pronounceWord(
                            controller.currentVocab.value.question, 'ja-JP');
                      } // for Japanese
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
