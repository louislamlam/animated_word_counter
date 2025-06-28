# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added

- Initial release of animated_word_counter
- Multi-language word counting support for 9 languages:
  - English (space-separated)
  - Chinese (character-based)
  - Japanese (mixed script)
  - Korean (Hangul syllables)
  - Thai (character-based)
  - Arabic (space-separated Arabic words)
  - Hebrew (space-separated Hebrew words)
  - Hindi (Devanagari script)
  - Auto-detection mode
- Three main widget types:
  - `AnimatedWordCounter` - Full-featured counter with statistics
  - `SimpleAnimatedWordCounter` - Basic counter display
  - `RealTimeAnimatedWordCounter` - Real-time updating counter
- Comprehensive statistics including:
  - Word count
  - Character count (with and without spaces)
  - Line count
  - Paragraph count
  - Language detection
- Customizable styling and animations
- Built on animated_flip_counter for smooth animations
- Debouncing support for real-time updates
- Complete example app demonstrating all features
- Comprehensive documentation and API reference

### Features

- Language-aware word counting algorithms
- Unicode character range detection
- Automatic language detection
- Customizable animation duration and curves
- Prefix and suffix text support
- Statistics display option
- Callback support for count changes
- Material Design integration
