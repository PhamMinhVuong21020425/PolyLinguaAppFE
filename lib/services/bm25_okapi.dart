import 'dart:math';

class BM25 {
  List<List<String>> tokenizedCorpus = [];
  int corpusSize = 0;
  double avgdl = 0;
  List<Map<String, int>> docFreqs = [];
  Map<String, double> idf = {};
  List<int> docLen = [];
  final Function(List<String>)? tokenizer;

  BM25(List<String> corpus, {this.tokenizer}) {
    if (tokenizer != null) {
      tokenizedCorpus = tokenizer!(corpus);
    } else {
      tokenizedCorpus = _tokenizeCorpus(corpus);
    }
    final nd = _initialize(tokenizedCorpus);
    _calcIdf(nd);
  }

  List<List<String>> _tokenizeCorpus(List<String> corpus) {
    // Assuming you have a tokenizer function, replace this with the appropriate implementation
    return corpus.map((doc) => doc.split(' ')).toList();
  }

  Map<String, int> _initialize(List<List<String>> corpus) {
    final nd = <String, int>{};
    int numDoc = 0;
    for (final document in corpus) {
      docLen.add(document.length);
      numDoc += document.length;

      final frequencies = <String, int>{};
      for (final word in document) {
        frequencies[word] = (frequencies[word] ?? 0) + 1;
      }
      docFreqs.add(frequencies);

      for (final entry in frequencies.entries) {
        nd[entry.key] = (nd[entry.key] ?? 0) + 1;
      }

      corpusSize += 1;
    }

    avgdl = numDoc / corpusSize;
    return nd;
  }

  void _calcIdf(Map<String, int> nd) {
    throw UnimplementedError();
  }

  List<double> getScores(List<String> query) {
    throw UnimplementedError();
  }

  List<double> getBatchScores(List<String> query, List<int> docIds) {
    throw UnimplementedError();
  }

  List<T> getTopN<T>(List<String> query, List<T> documents, int n) {
    final scores = getScores(query);
    final topNIndices = List.from(scores.asMap().keys)
      ..sort((a, b) => scores[b].compareTo(scores[a]));
    topNIndices.removeRange(n, topNIndices.length);
    return topNIndices.map((i) => documents[i]).toList();
  }
}

class BM25Okapi extends BM25 {
  final double k1;
  final double b;
  final double epsilon;

  BM25Okapi(
    super.corpus, {
    super.tokenizer,
    this.k1 = 1.5,
    this.b = 0.75,
    this.epsilon = 0.25,
  });

  @override
  void _calcIdf(Map<String, int> nd) {
    double idfSum = 0;
    final negativeIdfs = <String>[];
    for (final entry in nd.entries) {
      final idf = log((corpusSize - entry.value + 0.5) / (entry.value + 0.5));
      this.idf[entry.key] = idf;
      idfSum += idf;
      if (idf < 0) {
        negativeIdfs.add(entry.key);
      }
    }
    final averageIdf = idfSum / idf.length;
    final eps = epsilon * averageIdf;
    for (final word in negativeIdfs) {
      idf[word] = eps;
    }
  }

  @override
  List<double> getScores(List<String> query) {
    final score = List.filled(corpusSize, 0.0);
    final docLenArr = docLen.map((len) => len.toDouble()).toList();
    for (final q in query) {
      final qFreq = docFreqs.map((doc) => (doc[q] ?? 0).toDouble()).toList();
      for (int i = 0; i < corpusSize; i++) {
        score[i] += (idf[q] ?? 0) *
            (qFreq[i] * (k1 + 1)) /
            (qFreq[i] + k1 * (1 - b + b * docLenArr[i] / avgdl));
      }
    }
    return score;
  }

  @override
  List<double> getBatchScores(List<String> query, List<int> docIds) {
    final score = List.filled(docIds.length, 0.0);
    final docLenArr = docLen.map((len) => len.toDouble()).toList();
    for (final q in query) {
      final qFreq =
          docIds.map((di) => (docFreqs[di][q] ?? 0).toDouble()).toList();
      final filteredDocLen = docIds.map((di) => docLenArr[di]).toList();
      for (int i = 0; i < docIds.length; i++) {
        score[i] += (idf[q] ?? 0) *
            (qFreq[i] * (k1 + 1)) /
            (qFreq[i] + k1 * (1 - b + b * filteredDocLen[i] / avgdl));
      }
    }
    return score;
  }
}
