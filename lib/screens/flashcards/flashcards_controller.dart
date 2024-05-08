import 'package:get/get.dart';

class FlashcardsController extends GetxController {
  FlashcardsController();

  List<String> vocabList = [
    '人生',
    '祖先',
    '親戚',
    '天婦',
    '長男',
    '主人',
  ].obs;

  List<bool> isFavorite = List.filled(6, false).obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  void addVocab(String vocab) {
    vocabList.add(vocab);
  }

  void removeVocab(int index) {
    vocabList.removeAt(index);
    isFavorite.removeAt(index);
  }

  void updateVocab(int index, String vocab) {
    vocabList[index] = vocab;
  }

  void toggleFavorite(int index) {
    isFavorite[index] = !isFavorite[index];
  }
}
