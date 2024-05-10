import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';
import 'package:poly_lingua_app/screens/flashcards/reusable_card.dart';

class FlashcardsScreen extends GetView<FlashcardsController> {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flashcards"),
        toolbarHeight: 80,
        elevation: 5,
      ),
      body: Obx(
        () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Question ${controller.currentIndex.value + 1} of ${controller.vocabList.length}",
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Colors.pinkAccent),
                  minHeight: 5,
                  value: (controller.currentIndex.value + 1) /
                      controller.vocabList.length,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    controller.showNextCard();
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    if (animation.value == 1.0) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1.0, 0.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(animation),
                        child: child,
                      );
                    } else {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(animation),
                        child: child,
                      );
                    }
                  },
                  child: SizedBox(
                    key: ValueKey<int>(controller.currentIndex.value),
                    width: 300,
                    height: 300,
                    child: FlipCard(
                      direction: FlipDirection.VERTICAL,
                      front: ReusableCard(
                        text: controller
                            .vocabList[controller.currentIndex.value].question,
                      ),
                      back: ReusableCard(
                        text: controller
                            .vocabList[controller.currentIndex.value].answer,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Tab to see Answer",
                  style:
                      TextStyle(fontSize: 15, fontFamily: "Time News Roman")),
            ],
          ),
        ),
      ),
    );
  }
}
