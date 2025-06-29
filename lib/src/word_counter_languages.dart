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
      description: 'Character-based counting',
      countFunction: _countJapanese,
    ),
    WordCounterLanguage.korean: LanguageConfig(
      language: WordCounterLanguage.korean,
      name: 'Korean',
      description: 'Character-based counting',
      countFunction: _countKorean,
    ),
    WordCounterLanguage.thai: LanguageConfig(
      language: WordCounterLanguage.thai,
      name: 'Thai',
      description: 'Character-based counting',
      countFunction: _countThai,
    ),
    WordCounterLanguage.arabic: LanguageConfig(
      language: WordCounterLanguage.arabic,
      name: 'Arabic',
      description: 'Space-separated words',
      countFunction: _countArabic,
    ),
    WordCounterLanguage.hebrew: LanguageConfig(
      language: WordCounterLanguage.hebrew,
      name: 'Hebrew',
      description: 'Space-separated words',
      countFunction: _countHebrew,
    ),
    WordCounterLanguage.hindi: LanguageConfig(
      language: WordCounterLanguage.hindi,
      name: 'Hindi',
      description: 'Space-separated words',
      countFunction: _countHindi,
    ),
    WordCounterLanguage.auto: LanguageConfig(
      language: WordCounterLanguage.auto,
      name: 'Auto-detect',
      description: 'Automatic language detection',
      countFunction: _countAuto,
    ),
  };

  /// Get language configuration
  static LanguageConfig getConfig(WordCounterLanguage language) {
    return configs[language] ?? configs[WordCounterLanguage.auto]!;
  }

  // Performance threshold: use regex for short texts, runes for longer texts
  static const int _performanceThreshold = 50;

  /// Improved CJK character detection with correct Unicode ranges
  // static bool _isCJKCharacter(int rune) {
  //   return (rune >= 0x4E00 && rune <= 0x9FFF) || // CJK Unified Ideographs
  //       (rune >= 0x3040 && rune <= 0x309F) || // Hiragana
  //       (rune >= 0x30A0 && rune <= 0x30FF) || // Katakana
  //       (rune >= 0xAC00 && rune <= 0xD7A3) || // Hangul Syllables (CORRECTED!)
  //       (rune >= 0x1100 && rune <= 0x11FF) || // Hangul Jamo
  //       (rune >= 0x3130 && rune <= 0x318F); // Hangul Compatibility Jamo
  // }

  /// Fast character type detection for short texts
  static bool _hasChineseRegex(String text) =>
      RegExp(r'[\u4e00-\u9fff]').hasMatch(text);
  static bool _hasJapaneseRegex(String text) =>
      RegExp(r'[\u3040-\u309f\u30a0-\u30ff]').hasMatch(text);
  static bool _hasKoreanRegex(String text) =>
      RegExp(r'[\uac00-\ud7a3\u1100-\u11ff\u3130-\u318f]')
          .hasMatch(text); // FIXED RANGE

  // Word counting functions for different languages
  static int _countSpaceSeparated(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  static int _countChinese(String text) {
    if (text.trim().isEmpty) return 0;

    if (text.length < _performanceThreshold) {
      // Use regex for short texts
      return RegExp(r'[\u4e00-\u9fff]').allMatches(text).length;
    } else {
      // Use rune checking for longer texts (better performance)
      int count = 0;
      for (int rune in text.runes) {
        if (rune >= 0x4E00 && rune <= 0x9FFF) count++;
      }
      return count;
    }
  }

  static int _countJapanese(String text) {
    if (text.trim().isEmpty) return 0;

    if (text.length < _performanceThreshold) {
      // Use regex for short texts (better performance for Japanese)
      final japaneseChars =
          RegExp(r'[\u3040-\u309f\u30a0-\u30ff\u4e00-\u9fff]');
      final matches = japaneseChars.allMatches(text);

      final spaceSeparated = text.trim().split(RegExp(r'\s+'));
      final nonJapaneseWords = spaceSeparated
          .where((word) => !japaneseChars.hasMatch(word) && word.isNotEmpty)
          .length;

      return matches.length + nonJapaneseWords;
    } else {
      // Use rune checking for longer texts
      int cjkCount = 0;
      final List<String> words = text.trim().split(RegExp(r'\s+'));
      int nonCjkWords = 0;

      for (String word in words) {
        if (word.isEmpty) continue;

        bool hasCjk = false;
        for (int rune in word.runes) {
          if ((rune >= 0x3040 && rune <= 0x309F) || // Hiragana
              (rune >= 0x30A0 && rune <= 0x30FF) || // Katakana
              (rune >= 0x4E00 && rune <= 0x9FFF)) {
            // Kanji
            cjkCount++;
            hasCjk = true;
          }
        }

        if (!hasCjk && word.isNotEmpty) {
          nonCjkWords++;
        }
      }

      return cjkCount + nonCjkWords;
    }
  }

  static int _countKorean(String text) {
    if (text.trim().isEmpty) return 0;

    // Always use the corrected Unicode range with rune checking
    int count = 0;
    final List<String> words = text.trim().split(RegExp(r'\s+'));

    for (String word in words) {
      if (word.isEmpty) continue;

      bool hasKorean = false;
      for (int rune in word.runes) {
        if ((rune >= 0xAC00 &&
                rune <= 0xD7A3) || // Hangul Syllables (CORRECTED!)
            (rune >= 0x1100 && rune <= 0x11FF) || // Hangul Jamo
            (rune >= 0x3130 && rune <= 0x318F)) {
          // Hangul Compatibility Jamo
          count++;
          hasKorean = true;
        }
      }

      if (!hasKorean && word.isNotEmpty) {
        count++;
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

    // Quick detection for short texts
    if (text.length < _performanceThreshold) {
      if (_hasJapaneseRegex(text)) {
        return _countJapanese(text);
      } else if (_hasKoreanRegex(text)) {
        return _countKorean(text);
      } else if (_hasChineseRegex(text)) {
        return _countChinese(text);
      } else {
        // Check other languages with regex
        final thaiChars = RegExp(r'[\u0e00-\u0e7f]');
        final arabicChars = RegExp(r'[\u0600-\u06ff]');
        final hebrewChars = RegExp(r'[\u0590-\u05ff]');
        final hindiChars = RegExp(r'[\u0900-\u097f]');

        if (thaiChars.hasMatch(text)) {
          return _countThai(text);
        } else if (arabicChars.hasMatch(text)) {
          return _countArabic(text);
        } else if (hebrewChars.hasMatch(text)) {
          return _countHebrew(text);
        } else if (hindiChars.hasMatch(text)) {
          return _countHindi(text);
        } else {
          return _countSpaceSeparated(text);
        }
      }
    }

    // Detailed analysis for longer texts using improved CJK detection
    int chineseCount = 0;
    int japaneseSpecificCount = 0;
    int koreanCount = 0;
    int thaiCount = 0;
    int arabicCount = 0;
    int hebrewCount = 0;
    int hindiCount = 0;

    for (int rune in text.runes) {
      if (rune >= 0x4E00 && rune <= 0x9FFF) {
        chineseCount++;
      }
      if ((rune >= 0x3040 && rune <= 0x309F) || // Hiragana
          (rune >= 0x30A0 && rune <= 0x30FF)) {
        // Katakana
        japaneseSpecificCount++;
      }
      if ((rune >= 0xAC00 && rune <= 0xD7A3) || // Hangul Syllables (CORRECTED!)
          (rune >= 0x1100 && rune <= 0x11FF) || // Hangul Jamo
          (rune >= 0x3130 && rune <= 0x318F)) {
        // Hangul Compatibility Jamo
        koreanCount++;
      }
      if (rune >= 0x0E00 && rune <= 0x0E7F) {
        // Thai
        thaiCount++;
      }
      if (rune >= 0x0600 && rune <= 0x06FF) {
        // Arabic
        arabicCount++;
      }
      if (rune >= 0x0590 && rune <= 0x05FF) {
        // Hebrew
        hebrewCount++;
      }
      if (rune >= 0x0900 && rune <= 0x097F) {
        // Hindi
        hindiCount++;
      }
    }

    // Determine language based on character distribution
    if (japaneseSpecificCount > 0) {
      // Has Hiragana/Katakana, definitely Japanese
      return _countJapanese(text);
    } else if (koreanCount > 0) {
      // Has Korean characters
      return _countKorean(text);
    } else if (chineseCount > 0) {
      // Has Chinese characters (no Hiragana/Katakana)
      return _countChinese(text);
    } else if (thaiCount > 0) {
      return _countThai(text);
    } else if (arabicCount > 0) {
      return _countArabic(text);
    } else if (hebrewCount > 0) {
      return _countHebrew(text);
    } else if (hindiCount > 0) {
      return _countHindi(text);
    } else {
      // No special scripts, use space-separated counting
      return _countSpaceSeparated(text);
    }
  }
}
