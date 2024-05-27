import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Poly Lingua App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Poly Lingua App is a multilingual dictionary app that allows you read the news article and translate words between multiple languages. It can provide accurate translations and supports a wide range of languages.',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.0),
              Text('Features:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 8.0),
              ListBody(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Multilingual support for 2 languages: English and Japanese',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Read news articles in your preferred language',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Accurate translations and summarization powered by machine learning',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Customize Flashcards for learning new words and phrases',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Offline mode for translation without an internet connection',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'User-friendly interface with support for voice input and output',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
