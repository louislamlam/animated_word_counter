# Animated Word Counter

An animated word counter Flutter package that supports multiple languages with customizable styling, built on [animated_flip_counter](https://pub.dev/packages/animated_flip_counter).

[![pub package](https://img.shields.io/pub/v/animated_word_counter.svg)](https://pub.dev/packages/animated_word_counter)

## Features

- 🌍 **Multi-language support**: English, Chinese, Japanese, Korean, Thai, Arabic, Hebrew, Hindi, and auto-detection
- ✨ **Smooth animations**: Built with improved flip counter that fixes rendering issues
- 🎨 **Customizable styling**: Full control over text styles, colors, and animations
- ⏱️ **Real-time counting**: Updates as users type with debouncing support
- 📊 **Additional statistics**: Character count, line count, paragraph count
- 🚀 **Easy to use**: Simple API with sensible defaults
- 🔧 **Fixed Issues**: Resolves font rendering, text overflow, and RTL language issues
- 🌐 **RTL Support**: Full support for right-to-left languages like Arabic and Hebrew
- 📝 **Text Overflow**: Smart handling of long prefix and suffix text

## Supported Languages

| Language | Description           | Counting Method                    |
| -------- | --------------------- | ---------------------------------- |
| English  | Space-separated words | Split by whitespace                |
| Chinese  | Chinese characters    | CJK Unified Ideographs             |
| Japanese | Mixed script          | Hiragana, Katakana, Kanji + spaces |
| Korean   | Hangul syllables      | Hangul characters + spaces         |
| Thai     | Thai script           | Thai characters                    |
| Arabic   | Arabic script         | Space-separated Arabic words       |
| Hebrew   | Hebrew script         | Space-separated Hebrew words       |
| Hindi    | Devanagari script     | Space-separated Hindi words        |
| Auto     | Auto-detection        | Detects language automatically     |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  animated_word_counter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:animated_word_counter/animated_word_counter.dart';

// Simple word counter
SimpleAnimatedWordCounter(
  text: "Hello world! This is a sample text.",
  language: WordCounterLanguage.english,
)
```

### Advanced Usage

```dart
// Full-featured word counter with statistics
AnimatedWordCounter(
  text: yourText,
  language: WordCounterLanguage.auto,
  showStats: true,
  textStyle: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  prefix: 'Words: ',
  suffix: '',
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  onCountChanged: (stats) {
    print('Word count: ${stats.wordCount}');
    print('Characters: ${stats.characterCount}');
  },
)
```

### Real-time Counting

```dart
// Real-time counter that updates as user types
RealTimeAnimatedWordCounter(
  controller: textEditingController,
  language: WordCounterLanguage.auto,
  showStats: true,
  debounceDelay: Duration(milliseconds: 100),
)
```

### Language-specific Examples

```dart
// Chinese text counting
AnimatedWordCounter(
  text: "这是一个中文文本示例。用于演示汉字计数功能。",
  language: WordCounterLanguage.chinese,
)

// Japanese text counting
AnimatedWordCounter(
  text: "これは日本語のテキストサンプルです。",
  language: WordCounterLanguage.japanese,
)

// Auto-detection
AnimatedWordCounter(
  text: "Automatically detects the language",
  language: WordCounterLanguage.auto,
)
```

## API Reference

### AnimatedWordCounter

The main widget for displaying animated word counts.

#### Properties

| Property         | Type                            | Default     | Description                  |
| ---------------- | ------------------------------- | ----------- | ---------------------------- |
| `text`           | `String`                        | required    | The text to count words from |
| `language`       | `WordCounterLanguage`           | `auto`      | Language for word counting   |
| `duration`       | `Duration`                      | `500ms`     | Animation duration           |
| `curve`          | `Curve`                         | `easeInOut` | Animation curve              |
| `textStyle`      | `TextStyle?`                    | `null`      | Style for the counter text   |
| `prefix`         | `String`                        | `''`        | Text before the counter      |
| `suffix`         | `String`                        | `' words'`  | Text after the counter       |
| `showStats`      | `bool`                          | `false`     | Show additional statistics   |
| `onCountChanged` | `ValueChanged<WordCountStats>?` | `null`      | Callback when count changes  |

### SimpleAnimatedWordCounter

A simplified version that only shows the count.

### RealTimeAnimatedWordCounter

Updates in real-time as the user types in a connected TextEditingController.

#### Additional Properties

| Property        | Type                    | Default  | Description                   |
| --------------- | ----------------------- | -------- | ----------------------------- |
| `controller`    | `TextEditingController` | required | Text controller to listen to  |
| `debounceDelay` | `Duration`              | `100ms`  | Delay before updating counter |

### WordCountStats

Statistics returned by the counter.

```dart
class WordCountStats {
  final int wordCount;
  final int characterCount;
  final int characterCountNoSpaces;
  final int lineCount;
  final int paragraphCount;
  final WordCounterLanguage language;
}
```

### WordCounterLanguage

Enum defining supported languages:

- `WordCounterLanguage.english`
- `WordCounterLanguage.chinese`
- `WordCounterLanguage.japanese`
- `WordCounterLanguage.korean`
- `WordCounterLanguage.thai`
- `WordCounterLanguage.arabic`
- `WordCounterLanguage.hebrew`
- `WordCounterLanguage.hindi`
- `WordCounterLanguage.auto`

## Examples

Check out the [example](./example) directory for a complete demo app showcasing all features.

## Language Detection

The package uses Unicode character ranges to detect and count words appropriately for each language:

- **Space-separated languages** (English, etc.): Split by whitespace
- **Character-based languages** (Chinese): Count individual characters
- **Mixed scripts** (Japanese): Handle multiple writing systems
- **Syllable-based languages** (Korean): Count Hangul syllables
- **Script-specific counting**: Proper handling for Arabic, Hebrew, Hindi, Thai

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### ImprovedAnimatedFlipCounter

For advanced use cases, you can use the improved flip counter directly:

```dart
ImprovedAnimatedFlipCounter(
  value: 1234.56,
  fractionDigits: 2,
  thousandSeparator: ',',
  prefix: 'Total: \$',
  suffix: ' USD',
  // New features:
  supportRtl: true, // RTL language support
  improvedFontRendering: true, // Better font rendering
  maxSuffixWidth: 100, // Constrain suffix width
  suffixOverflow: TextOverflow.ellipsis, // Handle overflow
  fontFeatures: [FontFeature.tabularFigures()], // Custom font features
)
```

## Fixed Issues

This package resolves several issues found in the original animated_flip_counter:

- **Issue #30**: Weird font rendering - Fixed with improved font handling and baseline alignment
- **Issue #28**: Text overflow support - Added `maxPrefixWidth`, `maxSuffixWidth`, and overflow properties
- **Issue #16**: RTL language support - Added `supportRtl` property for proper right-to-left text handling
- **Issue #24**: Version stability - Improved animation stability and performance

## Credits

Originally inspired by [animated_flip_counter](https://pub.dev/packages/animated_flip_counter) by [Felix Angelov](https://github.com/felangel), with significant improvements and bug fixes.
