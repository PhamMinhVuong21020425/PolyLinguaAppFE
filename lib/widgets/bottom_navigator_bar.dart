import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  final bool darkMode;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.darkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: darkMode ? Colors.white : Colors.black,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.card_membership_sharp,
              color: darkMode ? Colors.white : Colors.black,
            ),
            label: 'Flashcards'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: darkMode ? Colors.white : Colors.black,
            ),
            label: 'Favorites'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: darkMode ? Colors.white : Colors.black,
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
