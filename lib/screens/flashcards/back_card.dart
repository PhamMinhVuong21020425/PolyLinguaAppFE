import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/screens/flashcards/flashcards_controller.dart';

class BackCard extends StatefulWidget {
  const BackCard({super.key, required this.text});
  final Flashcard text;

  @override
  State<BackCard> createState() => _BackCardState();
}

class _BackCardState extends State<BackCard> {
  bool _isEditing = false;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final flashcardsController = Get.find<FlashcardsController>();

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.text.question;
    _answerController.text = widget.text.answer;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(
        () => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isEditing
                          ? Expanded(
                              child: TextField(
                                controller: _questionController,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Time News Roman",
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter question',
                                ),
                              ),
                            )
                          : Text(
                              flashcardsController.currentVocab.value.question,
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: "Time News Roman",
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                      ),
                    ],
                  ),
                  _isEditing
                      ? TextField(
                          maxLines: 5,
                          controller: _answerController,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Time News Roman",
                            letterSpacing: 1.0,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter answer',
                          ),
                        )
                      : Text(
                          flashcardsController.currentVocab.value.answer,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Time News Roman",
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                  if (_isEditing) const SizedBox(height: 16.0),
                  if (_isEditing)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _cancelChanges,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        TextButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
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
  }

  void _saveChanges() {
    // Implement your save logic here
    final FlashcardsController flashcardsController = Get.find();
    final Flashcard originVocab = flashcardsController.currentVocab.value;
    final newVocab = Flashcard(
      question: _questionController.text,
      answer: _answerController.text,
      language: flashcardsController.currentVocab.value.language,
      star: flashcardsController.currentVocab.value.star,
    );

    flashcardsController.updateVocab(originVocab, newVocab);

    setState(() {
      _isEditing = false;
    });
  }

  void _cancelChanges() {
    // Implement your cancel logic here
    _questionController.text = flashcardsController.currentVocab.value.question;
    _answerController.text = flashcardsController.currentVocab.value.answer;
    setState(() {
      _isEditing = false;
    });
  }
}
