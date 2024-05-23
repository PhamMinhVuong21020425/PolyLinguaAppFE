import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();

Future<void> pronounceWord(String word, String language) async {
  await flutterTts.setVolume(1.0);
  await flutterTts.setSpeechRate(0.5); // Lower speech rate (speed) of the voice
  await flutterTts.setPitch(1.0); // Higher frequency (pitch) of the voice
  await flutterTts.setLanguage(language);
  await flutterTts.speak(word);
}
