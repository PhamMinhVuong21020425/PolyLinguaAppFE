import 'package:flutter/material.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/utils/pronounce_word.dart';

class FrontCard extends StatelessWidget {
  const FrontCard({super.key, required this.text});
  final Flashcard text;

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
                Text(
                  text.question,
                  style: const TextStyle(
                    fontSize: 32,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                    icon: const Icon(Icons.volume_up_outlined),
                    iconSize: 30,
                    onPressed: () {
                      if (text.language == "en") {
                        pronounceWord(text.question, 'en-US');
                      } // for English
                      if (text.language == "ja") {
                        pronounceWord(text.question, 'ja-JP');
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
