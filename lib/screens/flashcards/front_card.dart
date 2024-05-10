import 'package:flutter/material.dart';

class BackCard extends StatelessWidget {
  const BackCard({super.key, required this.text});
  final String text;

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
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                letterSpacing: 1.0,
                fontFamily: "Time News Roman",
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
