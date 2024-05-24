import 'package:get/get.dart';
import 'package:poly_lingua_app/classes/flashcard.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class FlashcardsController extends GetxController {
  FlashcardsController();
  double scaleFactor = 0.8;

  final UserController userController = Get.find<UserController>();

  List<Flashcard> vocabList = <Flashcard>[].obs;
  List<Flashcard> japaneseVocabList = <Flashcard>[].obs;
  List<Flashcard> englishVocabList = <Flashcard>[].obs;
  List<Flashcard> starVocabList = <Flashcard>[].obs;
  Rx<Flashcard> currentVocab =
      Flashcard(answer: '', question: '', language: '').obs;

  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    vocabList = userController.user!.vocabularies ?? [];
    japaneseVocabList =
        vocabList.where((element) => element.language == 'ja').toList();
    englishVocabList =
        vocabList.where((element) => element.language == 'en').toList();
    starVocabList = vocabList.where((element) => element.star).toList();
  }

  void handlePage(int index, String typeList) {
    onInit();
    currentIndex.value = index;
    if (typeList == "japanese") {
      currentVocab.value = japaneseVocabList[index];
    } else if (typeList == "english") {
      currentVocab.value = englishVocabList[index];
    } else {
      currentVocab.value = starVocabList[index];
    }
  }

  void addVocab(Flashcard vocab) {
    vocabList.insert(0, vocab);
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void updateVocab(Flashcard originVocab, Flashcard newVocab) {
    int index = vocabList
        .indexWhere((element) => element.question == originVocab.question);
    vocabList[index] = newVocab;
    currentVocab.value = newVocab;
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void toggleStar(Flashcard vocab, bool isStar) {
    if (isStar) {
      vocabList.insert(0, vocab);
    } else {
      vocabList.removeWhere((element) => element.question == vocab.question);
    }

    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void toggleVocabularyStar(int index) {
    Flashcard vocab = starVocabList[index];
    vocabList.firstWhere((element) => element.question == vocab.question).star =
        !vocab.star;
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void toggleJapaneseVocabularyStar(int index) {
    Flashcard vocab = japaneseVocabList[index];
    vocabList.firstWhere((element) => element.question == vocab.question).star =
        !vocab.star;
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void toggleEnglishVocabularyStar(int index) {
    Flashcard vocab = englishVocabList[index];
    vocabList.firstWhere((element) => element.question == vocab.question).star =
        !vocab.star;
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void removeJapaneseVocabulary(int index) {
    Flashcard vocab = japaneseVocabList[index];
    vocabList.removeWhere((element) => element.question == vocab.question);
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }

  void removeEnglishVocabulary(int index) {
    Flashcard vocab = englishVocabList[index];
    vocabList.removeWhere((element) => element.question == vocab.question);
    userController.updateUser(vocabularies: vocabList);
    onInit();
  }
}
