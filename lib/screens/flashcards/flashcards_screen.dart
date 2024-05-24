import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/front_card.dart';
import 'package:poly_lingua_app/screens/flashcards/back_card.dart';

class FlashcardsScreen extends GetView<FlashcardsController> {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Flashcard> listVocabulary = Get.arguments["data"];
    final String typeList = Get.arguments["type"];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flashcards"),
        toolbarHeight: 80,
        elevation: 5,
      ),
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Question ${controller.currentIndex.value + 1} of ${listVocabulary.length}",
                  style: const TextStyle(fontSize: 15)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Colors.pinkAccent),
                  minHeight: 5,
                  value: (controller.currentIndex.value + 1) /
                      listVocabulary.length,
                ),
              ),
              SizedBox(
                height: 500,
                child: Center(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      controller.handlePage(index, typeList);
                    },
                    controller: PageController(
                      initialPage: controller.currentIndex.value,
                      viewportFraction: 1.0,
                    ),
                    itemCount: listVocabulary.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemFlashCard(index, listVocabulary);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemFlashCard extends GetView<FlashcardsController> {
  final int index;
  final List<Flashcard> listVocabulary;
  const ItemFlashCard(this.index, this.listVocabulary, {super.key});

  @override
  Widget build(BuildContext context) {
    Matrix4 matrix4 = Matrix4.identity();
    if (index == controller.currentIndex.floor()) {
      var currScale = 1 -
          (controller.currentIndex.value - index) *
              (1 - controller.scaleFactor);
      var currTrans = 200 * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == controller.currentIndex.floor() + 1) {
      var currScale = controller.scaleFactor +
          (controller.currentIndex.value - index + 1) *
              (1 - controller.scaleFactor);
      var currTrans = 200 * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == controller.currentIndex.floor() - 1) {
      var currScale = 1 -
          (controller.currentIndex.value - index) *
              (1 - controller.scaleFactor);
      var currTrans = 200 * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, 200 * (1 - currScale) / 2, 1);
    }
    return Transform(
      transform: matrix4,
      child: FlipCard(
        direction: FlipDirection.VERTICAL,
        front: const FrontCard(),
        back: BackCard(
          text: listVocabulary[index],
        ),
      ),
    );
  }
}
