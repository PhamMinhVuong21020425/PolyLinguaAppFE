String stemEnglishWord(String word) {
  // Convert word to lowercase
  word = word.toLowerCase();

  Map<String, String> specialCases = {
    "bring": "bring",
    "running": "running",
    "scuffing": "scuffing",
    "scuffed": "scuff",
  };

  if (specialCases.containsKey(word)) {
    return specialCases[word]!;
  }

  // Define patterns and replacements for common verb conjugations
  Map<String, String> verbPatterns = {
    r'([\w]*)ied$': r'$1y',
    r'([\w]*)ed$': r'$1',
    r'([\w]*)ing$': r'$1',
    r'([\w]*)ies$': r'$1y',
    r'([\w]*)ses$': r'$1s',
    r'([\w]*)es$': r'$1',
    r'([\w]*)s$': r'$1',
  };

  // Iterate through patterns and apply replacements
  for (String pattern in verbPatterns.keys) {
    final regExp = RegExp(pattern);
    if (regExp.hasMatch(word)) {
      word = word.replaceAllMapped(regExp, (match) {
        return verbPatterns[pattern]!.replaceAll(r'$1', match.group(1)!);
      });
      break;
    }
  }

  if (word[word.length - 2] == word[word.length - 1] &&
      word[word.length - 1] != 's' &&
      word[word.length - 1] != 'l') {
    word = word.substring(0, word.length - 1);
  }

  return word;
}

String singularize(String word) {
  // Convert word to lowercase
  word = word.toLowerCase();

  Map<String, String> specialCases = {
    "mice": "mouse",
    "lice": "louse",
    "men": "man",
    "women": "woman",
    "feet": "foot",
    "teeth": "tooth",
    "geese": "goose",
    "leaves": "leaf",
    "lives": "life",
    "times": "times",
    "something": "something",
    "gagging": "gagging",
  };

  if (specialCases.containsKey(word)) {
    return specialCases[word]!;
  }

  // Define patterns and replacements for common plural noun endings
  Map<String, String> pluralPatterns = {
    r'([\w]*)ies$': r'$1y',
    r'([\w]*)sses$': r'$1ss',
    r'([\w]*)shes$': r'$1sh',
    r'([\w]*)ches$': r'$1ch',
    r'([\w]*)xes$': r'$1x',
    r'([\w]*)zes$': r'$1z',
    r'([\w]*)ves$': r'$1f',
    r'([\w]*)ss$': r'$1ss',
    r'([\w]*)s$': r'$1',
    r'([\w]*)ing$': r'$1',
  };

  // Iterate through patterns and apply replacements
  for (String pattern in pluralPatterns.keys) {
    final regExp = RegExp(pattern);
    if (regExp.hasMatch(word)) {
      return word.replaceAllMapped(regExp, (match) {
        return pluralPatterns[pattern]!.replaceAll(r'$1', match.group(1)!);
      });
    }
  }

  return word;
}
