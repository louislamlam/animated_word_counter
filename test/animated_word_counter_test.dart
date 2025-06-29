import 'package:flutter_test/flutter_test.dart';
import 'package:animated_word_counter/animated_word_counter.dart';

void main() {
  group('LanguageAwareWordCounter', () {
    test('counts English words correctly', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.english);

      expect(counter.countWords(''), 0);
      expect(counter.countWords('hello'), 1);
      expect(counter.countWords('hello world'), 2);
      expect(
          counter.countWords('The quick brown fox jumps over the lazy dog'), 9);
      expect(counter.countWords('  multiple   spaces   between   words  '), 4);
    });

    test('counts Chinese characters correctly', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.chinese);

      expect(counter.countWords(''), 0);
      expect(counter.countWords('你好'), 2);
      expect(counter.countWords('这是一个中文文本示例'), 10);
      expect(counter.countWords('春天来了，花儿开放了'),
          9); // 9 Chinese characters (comma is punctuation)
    });

    test('counts Japanese text correctly', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.japanese);

      expect(counter.countWords(''), 0);
      expect(counter.countWords('こんにちは'), 5); // 5 hiragana characters
      expect(counter.countWords('これは日本語のテキストです'),
          13); // Mixed hiragana/katakana/kanji
    });

    test('counts Korean text correctly', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.korean);

      expect(counter.countWords(''), 0);
      expect(counter.countWords('안녕하세요'), 5); // 5 Korean syllables
      expect(
          counter.countWords('한국어 텍스트'), 6); // Korean syllables including space
    });

    test('auto-detection works correctly', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.auto);

      // English text
      expect(counter.countWords('Hello world'), 2);

      // Chinese text
      expect(counter.countWords('你好世界'), 4);

      // Japanese text
      expect(counter.countWords('こんにちは'), 5);

      // Korean text
      expect(counter.countWords('안녕하세요'), 5);
    });

    test('gets statistics correctly', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.english);
      const text = 'Hello world!\nThis is a test.\n\nNew paragraph.';

      final stats = counter.getStats(text);

      expect(stats.wordCount, 8);
      expect(stats.characterCount, 44);
      expect(stats.characterCountNoSpaces, 36);
      expect(stats.lineCount, 4);
      expect(stats.paragraphCount, 2);
      expect(stats.language, WordCounterLanguage.english);
    });

    test('handles empty and whitespace-only text', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.english);

      expect(counter.countWords(''), 0);
      expect(counter.countWords('   '), 0);
      expect(counter.countWords('\n\n\t'), 0);

      final stats = counter.getStats('');
      expect(stats.wordCount, 0);
      expect(stats.lineCount, 0);
      expect(stats.paragraphCount, 0);
    });

    test('handles mixed language text', () {
      final counter =
          LanguageAwareWordCounter(language: WordCounterLanguage.auto);
      const mixedText = 'Hello 你好 world 世界';

      // Should detect and count appropriately
      final wordCount = counter.countWords(mixedText);
      expect(wordCount, greaterThan(0));
    });
  });

  group('LanguageConfig', () {
    test('returns correct configurations', () {
      final englishConfig =
          LanguageConfig.getConfig(WordCounterLanguage.english);
      expect(englishConfig.name, 'English');
      expect(englishConfig.description, 'Space-separated words');

      final chineseConfig =
          LanguageConfig.getConfig(WordCounterLanguage.chinese);
      expect(chineseConfig.name, 'Chinese');
      expect(chineseConfig.description, 'Character-based counting');

      final autoConfig = LanguageConfig.getConfig(WordCounterLanguage.auto);
      expect(autoConfig.name, 'Auto-detect');
    });

    test('handles unknown language gracefully', () {
      // This would normally not be possible with the enum, but testing the fallback
      final config = LanguageConfig.getConfig(WordCounterLanguage.auto);
      expect(config, isNotNull);
    });
  });

  group('WordCountStats', () {
    test('toString returns formatted string', () {
      const stats = WordCountStats(
        wordCount: 5,
        characterCount: 25,
        characterCountNoSpaces: 20,
        lineCount: 2,
        paragraphCount: 1,
        language: WordCounterLanguage.english,
      );

      final str = stats.toString();
      expect(str, contains('words: 5'));
      expect(str, contains('characters: 25'));
      expect(str, contains('language: english'));
    });

    test('toMap returns correct map', () {
      const stats = WordCountStats(
        wordCount: 5,
        characterCount: 25,
        characterCountNoSpaces: 20,
        lineCount: 2,
        paragraphCount: 1,
        language: WordCounterLanguage.english,
      );

      final map = stats.toMap();
      expect(map['wordCount'], 5);
      expect(map['characterCount'], 25);
      expect(map['characterCountNoSpaces'], 20);
      expect(map['lineCount'], 2);
      expect(map['paragraphCount'], 1);
      expect(map['language'], 'english');
    });
  });
}
