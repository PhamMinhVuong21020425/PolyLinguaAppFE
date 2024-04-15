import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.card_membership_sharp,
              color: Colors.black,
            ),
            label: 'Flashcards'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            label: 'Favorite'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: 'Settings')
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Get.toNamed('/home');
            break;
          case 1:
            Get.toNamed('/flashcards');
            break;
          case 2:
            Get.toNamed('/favorite');
            break;
          case 3:
            Get.toNamed('/settings');
            break;
          default:
            Get.toNamed('/article');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
    );
  }
}
