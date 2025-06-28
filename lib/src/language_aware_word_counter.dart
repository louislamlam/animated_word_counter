import 'word_counter_languages.dart';

/// A language-aware word counter that can count words in different languages
class LanguageAwareWordCounter {
  LanguageAwareWordCounter({
    this.language = WordCounterLanguage.auto,
  });

  /// The language to use for word counting
  final WordCounterLanguage language;

  /// Count words in the given text using the specified language rules
  int countWords(String text) {
    final config = LanguageConfig.getConfig(language);
    return config.countFunction(text);
  }

  /// Get the configuration for the current language
  LanguageConfig get config => LanguageConfig.getConfig(language);

  /// Create a new counter with a different language
  LanguageAwareWordCounter withLanguage(WordCounterLanguage newLanguage) {
    return LanguageAwareWordCounter(language: newLanguage);
  }

  /// Get statistics about the text
  WordCountStats getStats(String text) {
    final wordCount = countWords(text);
    final characterCount = text.length;
    final characterCountNoSpaces = text.replaceAll(RegExp(r'\s'), '').length;
    final lineCount = text.isEmpty ? 0 : text.split('\n').length;
    final paragraphCount =
        text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\n\s*\n')).length;

    return WordCountStats(
      wordCount: wordCount,
      characterCount: characterCount,
      characterCountNoSpaces: characterCountNoSpaces,
      lineCount: lineCount,
      paragraphCount: paragraphCount,
      language: language,
    );
  }
}

/// Statistics about the counted text
class WordCountStats {
  const WordCountStats({
    required this.wordCount,
    required this.characterCount,
    required this.characterCountNoSpaces,
    required this.lineCount,
    required this.paragraphCount,
    required this.language,
  });

  final int wordCount;
  final int characterCount;
  final int characterCountNoSpaces;
  final int lineCount;
  final int paragraphCount;
  final WordCounterLanguage language;

  @override
  String toString() {
    return 'WordCountStats('
        'words: $wordCount, '
        'characters: $characterCount, '
        'charactersNoSpaces: $characterCountNoSpaces, '
        'lines: $lineCount, '
        'paragraphs: $paragraphCount, '
        'language: ${language.name}'
        ')';
  }

  /// Convert to a map for easy serialization
  Map<String, dynamic> toMap() {
    return {
      'wordCount': wordCount,
      'characterCount': characterCount,
      'characterCountNoSpaces': characterCountNoSpaces,
      'lineCount': lineCount,
      'paragraphCount': paragraphCount,
      'language': language.name,
    };
  }
}
