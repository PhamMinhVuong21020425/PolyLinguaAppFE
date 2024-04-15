import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the home page
            Get.toNamed('/home');
          },
        ),
        title: const Text('Favorites'),
      ),
      body: const Center(
        child: Text('No favorites yet'),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
