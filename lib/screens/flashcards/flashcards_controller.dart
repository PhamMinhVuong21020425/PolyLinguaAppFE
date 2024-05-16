import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';

class FlashcardsController extends GetxController {
  FlashcardsController();
  double scaleFactor = 0.8;

  final vocabList = [
    Flashcard(question: "人生", answer: "Cuộc sống", language: "ja"),
    Flashcard(question: "祖先", answer: "Tổ tiên", language: "ja"),
    Flashcard(question: "長男", answer: "Đứa con trai đầu lòng", language: "ja"),
    Flashcard(question: "親戚", answer: "Họ hàng", language: "ja"),
    Flashcard(question: "天婦", answer: "Thiên phụ", language: "ja"),
    Flashcard(question: "主人", answer: "Chủ nhân", language: "ja"),
    Flashcard(question: "家庭", answer: "Gia đình", language: "ja"),
    Flashcard(question: "改善", answer: "Cải thiện", language: "ja"),
    Flashcard(question: "環境", answer: "Môi trường", language: "ja"),
    Flashcard(question: "手間", answer: "Thời gian và công sức", language: "ja"),
    Flashcard(question: "犠牲", answer: "Hy sinh", language: "ja"),
  ].obs;

  final currentIndex = 0.obs;

  void handlePage(int index) {
    currentIndex.value = index;
  }

  // void addVocab(String vocab) {
  //   vocabList.add(vocab);
  // }

  void removeVocab(int index) {
    vocabList.removeAt(index);
  }

  // void updateVocab(int index, String vocab) {
  //   vocabList[index] = vocab;
  // }

  void toggleStar(int index) {
    Flashcard e = vocabList[index];
    vocabList.removeAt(index);

    e.star = !(e.star);
    vocabList.insert(index, e);
  }

  void showNextCard() {
    currentIndex.value = (currentIndex.value + 1 < vocabList.length)
        ? currentIndex.value + 1
        : 0;
  }

  void showPreviousCard() {
    currentIndex.value = (currentIndex.value - 1 >= 0)
        ? currentIndex.value - 1
        : vocabList.length - 1;
  }
}
