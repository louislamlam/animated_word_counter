/// Enum representing different languages supported by the word counter
enum WordCounterLanguage {
  /// English and other space-separated languages
  english,

  /// Chinese (Simplified and Traditional)
  chinese,

  /// Japanese
  japanese,

  /// Korean
  korean,

  /// Thai
  thai,

  /// Arabic
  arabic,

  /// Hebrew
  hebrew,

  /// Hindi and other Devanagari scripts
  hindi,

  /// Auto-detect language (default)
  auto,
}

/// Configuration class for language-specific word counting
class LanguageConfig {
  const LanguageConfig({
    required this.language,
    required this.name,
    required this.countFunction,
    this.description,
  });

  final WordCounterLanguage language;
  final String name;
  final String? description;
  final int Function(String text) countFunction;

  static const Map<WordCounterLanguage, LanguageConfig> configs = {
    WordCounterLanguage.english: LanguageConfig(
      language: WordCounterLanguage.english,
      name: 'English',
      description: 'Space-separated words',
      countFunction: _countSpaceSeparated,
    ),
    WordCounterLanguage.chinese: LanguageConfig(
      language: WordCounterLanguage.chinese,
      name: 'Chinese',
      description: 'Character-based counting',
      countFunction: _countChinese,
    ),
    WordCounterLanguage.japanese: LanguageConfig(
      language: WordCounterLanguage.japanese,
      name: 'Japanese',
      description: 'Mixed script counting',
      countFunction: _countJapanese,
    ),
    WordCounterLanguage.korean: LanguageConfig(
      language: WordCounterLanguage.korean,
      name: 'Korean',
      description: 'Hangul-based counting',
      countFunction: _countKorean,
    ),
    WordCounterLanguage.thai: LanguageConfig(
      language: WordCounterLanguage.thai,
      name: 'Thai',
      description: 'Thai script counting',
      countFunction: _countThai,
    ),
    WordCounterLanguage.arabic: LanguageConfig(
      language: WordCounterLanguage.arabic,
      name: 'Arabic',
      description: 'Arabic script counting',
      countFunction: _countArabic,
    ),
    WordCounterLanguage.hebrew: LanguageConfig(
      language: WordCounterLanguage.hebrew,
      name: 'Hebrew',
      description: 'Hebrew script counting',
      countFunction: _countHebrew,
    ),
    WordCounterLanguage.hindi: LanguageConfig(
      language: WordCounterLanguage.hindi,
      name: 'Hindi',
      description: 'Devanagari script counting',
      countFunction: _countHindi,
    ),
    WordCounterLanguage.auto: LanguageConfig(
      language: WordCounterLanguage.auto,
      name: 'Auto-detect',
      description: 'Automatically detect language',
      countFunction: _countAuto,
    ),
  };

  /// Get language configuration
  static LanguageConfig getConfig(WordCounterLanguage language) {
    return configs[language] ?? configs[WordCounterLanguage.auto]!;
  }

  // Word counting functions for different languages
  static int _countSpaceSeparated(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  static int _countChinese(String text) {
    if (text.trim().isEmpty) return 0;
    // Count Chinese characters (CJK Unified Ideographs)
    final chineseChars = RegExp(r'[\u4e00-\u9fff]');
    final matches = chineseChars.allMatches(text);
    return matches.length;
  }

  static int _countJapanese(String text) {
    if (text.trim().isEmpty) return 0;
    // Count Japanese characters (Hiragana, Katakana, and Kanji)
    final japaneseChars = RegExp(r'[\u3040-\u309f\u30a0-\u30ff\u4e00-\u9fff]');
    final matches = japaneseChars.allMatches(text);

    // Also handle mixed text with spaces
    final spaceSeparated = text.trim().split(RegExp(r'\s+'));
    final nonJapaneseWords = spaceSeparated
        .where((word) => !japaneseChars.hasMatch(word) && word.isNotEmpty)
        .length;

    return matches.length + nonJapaneseWords;
  }

  static int _countKorean(String text) {
    if (text.trim().isEmpty) return 0;
    // Count Korean characters (Hangul)
    final koreanChars = RegExp(r'[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f]');

    // Split by spaces and count Korean syllables and non-Korean words
    final words = text.trim().split(RegExp(r'\s+'));
    int count = 0;

    for (final word in words) {
      if (word.isEmpty) continue;
      if (koreanChars.hasMatch(word)) {
        // Count Korean syllables
        count += koreanChars.allMatches(word).length;
      } else {
        // Count as one word for non-Korean text
        count += 1;
      }
    }

    return count;
  }

  static int _countThai(String text) {
    if (text.trim().isEmpty) return 0;
    // Thai doesn't use spaces between words, so we count characters
    final thaiChars = RegExp(r'[\u0e00-\u0e7f]');
    final matches = thaiChars.allMatches(text);

    // Also handle mixed text with spaces for non-Thai words
    final nonThaiWords = text
        .split(RegExp(r'[\u0e00-\u0e7f]+'))
        .join(' ')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;

    return matches.length + (nonThaiWords > 1 ? nonThaiWords : 0);
  }

  static int _countArabic(String text) {
    if (text.trim().isEmpty) return 0;
    // Count Arabic words (space-separated)
    final arabicText = text.replaceAll(RegExp(r'[^\u0600-\u06ff\s]'), ' ');
    return _countSpaceSeparated(arabicText);
  }

  static int _countHebrew(String text) {
    if (text.trim().isEmpty) return 0;
    // Count Hebrew words (space-separated)
    final hebrewText = text.replaceAll(RegExp(r'[^\u0590-\u05ff\s]'), ' ');
    return _countSpaceSeparated(hebrewText);
  }

  static int _countHindi(String text) {
    if (text.trim().isEmpty) return 0;
    // Count Hindi/Devanagari words (space-separated)
    final hindiText = text.replaceAll(RegExp(r'[^\u0900-\u097f\s]'), ' ');
    return _countSpaceSeparated(hindiText);
  }

  static int _countAuto(String text) {
    if (text.trim().isEmpty) return 0;

    // Auto-detect language based on character patterns
    final chineseChars = RegExp(r'[\u4e00-\u9fff]');
    final japaneseChars = RegExp(r'[\u3040-\u309f\u30a0-\u30ff]');
    final koreanChars = RegExp(r'[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f]');
    final thaiChars = RegExp(r'[\u0e00-\u0e7f]');
    final arabicChars = RegExp(r'[\u0600-\u06ff]');
    final hebrewChars = RegExp(r'[\u0590-\u05ff]');
    final hindiChars = RegExp(r'[\u0900-\u097f]');

    // Count different script types
    final chineseCount = chineseChars.allMatches(text).length;
    final japaneseCount = japaneseChars.allMatches(text).length;
    final koreanCount = koreanChars.allMatches(text).length;
    final thaiCount = thaiChars.allMatches(text).length;
    final arabicCount = arabicChars.allMatches(text).length;
    final hebrewCount = hebrewChars.allMatches(text).length;
    final hindiCount = hindiChars.allMatches(text).length;

    // Determine predominant script
    if (chineseCount > 0 && chineseCount >= japaneseCount) {
      return _countChinese(text);
    } else if (japaneseCount > 0) {
      return _countJapanese(text);
    } else if (koreanCount > 0) {
      return _countKorean(text);
    } else if (thaiCount > 0) {
      return _countThai(text);
    } else if (arabicCount > 0) {
      return _countArabic(text);
    } else if (hebrewCount > 0) {
      return _countHebrew(text);
    } else if (hindiCount > 0) {
      return _countHindi(text);
    } else {
      // Default to space-separated counting
      return _countSpaceSeparated(text);
    }
  }
}
