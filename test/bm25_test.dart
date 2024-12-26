import 'package:flutter_test/flutter_test.dart';
import 'package:poly_lingua_app/services/bm25_okapi.dart';

void main() {
  group('BM25Okapi - Tests', () {
    test('Initialization and Tokenization - Basic Case', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      // Tokenization check
      expect(bm25.tokenizedCorpus, [
        ['this', 'is', 'a', 'test'],
        ['this', 'is', 'another', 'test']
      ]);

      // Average document length
      expect(bm25.avgdl, closeTo(4.0, 0.001));
      expect(bm25.corpusSize, equals(2));
    });

    test('Initialization - Empty Corpus', () {
      final bm25 = BM25Okapi([]);

      expect(bm25.corpusSize, equals(0));
      expect(bm25.avgdl, equals(0));
      expect(bm25.tokenizedCorpus, isEmpty);
    });

    test('IDF Calculation - Valid Corpus', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      // Check specific IDF values
      expect(bm25.idf['this'], isNotNull);
      expect(bm25.idf['this'], greaterThan(0));
      expect(bm25.idf['another'], greaterThan(0));
    });

    test('getScores - Single Query Word', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final scores = bm25.getScores(['this']);
      expect(scores.length, equals(2));
      expect(scores[0], greaterThan(0));
      expect(scores[1], greaterThan(0));
    });

    test('getScores - Empty Query', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final scores = bm25.getScores([]);
      expect(scores, everyElement(equals(0.0)));
    });

    test('getScores - Query Not in Corpus', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final scores = bm25.getScores(['nonexistent']);
      expect(scores, everyElement(equals(0.0)));
    });

    test('getTopN - Top Documents', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final topDocs = bm25.getTopN(['this'], corpus, 1);
      expect(topDocs.length, equals(1));
      expect(corpus.contains(topDocs.first), isTrue);
    });

    test('getTopN - Empty Query', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final topDocs = bm25.getTopN([], corpus, 1);
      expect(topDocs, isEmpty);
    });

    test('getBatchScores - Valid Input', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final batchScores = bm25.getBatchScores(['this'], [0, 1]);
      expect(batchScores.length, equals(2));
      expect(batchScores[0], greaterThan(0));
      expect(batchScores[1], greaterThan(0));
    });

    test('getBatchScores - Invalid Document IDs', () {
      final corpus = ['this is a test', 'this is another test'];
      final bm25 = BM25Okapi(corpus);

      final batchScores = bm25.getBatchScores(['this'], [2, 3]);
      expect(batchScores, everyElement(equals(0.0)));
    });
  });
}
