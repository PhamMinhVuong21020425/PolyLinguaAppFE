import 'package:flutter/material.dart';

Widget checkImageNetwork(String imageUrl, BuildContext context) {
  return Image.network(
    imageUrl,
    width: MediaQuery.of(context).size.width * 0.3,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      // Handle 404 error and render default image
      if (error is NetworkImageLoadException) {
        return Image.asset(
          'assets/images/asahi.jpg',
          width: MediaQuery.of(context).size.width * 0.3,
          fit: BoxFit.cover,
        );
      }
      // Handle other errors
      return Container();
    },
    loadingBuilder: (context, child, loadingProgress) {
      // Handle loading state if needed
      if (loadingProgress == null) {
        return child;
      }
      return Center(
          child: Image.asset(
        'assets/images/news.png',
        width: MediaQuery.of(context).size.width * 0.3,
        fit: BoxFit.cover,
      ));
    },
  );
}
