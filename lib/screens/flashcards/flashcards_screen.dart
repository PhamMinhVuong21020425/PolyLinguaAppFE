import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';

class FlashcardsScreen extends StatelessWidget {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/home');
          },
        ),
        title: const Text('Flashcards'),
      ),
      body: ListView(
        children: const [
          CardItem(
            title: 'English Flashcard',
            description: 'English Flashcard',
            imageUrl: 'assets/images/flashcard.jpg',
            numWords: 0,
          ),
          SizedBox(height: 10),
          CardItem(
            title: 'Japanese Flashcard',
            description: 'Japanese Flashcard',
            imageUrl: 'assets/images/flashcard2.jpg',
            numWords: 0,
          ),
          SizedBox(height: 10),
          CardItem(
            title: 'Star Flashcard',
            description: 'Star Flashcard',
            imageUrl: 'assets/images/flashcard4.jpg',
            numWords: 0,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int numWords;

  const CardItem({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.numWords,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/vocabulary');
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 61, 8, 125),
              )),
          subtitle: Text(
            description,
            style: const TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
