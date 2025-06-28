# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2024-01-15

### Added

- Integrated and improved AnimatedFlipCounter directly into the package
- Fixed Issue #30: Weird font rendering with improved font handling
- Fixed Issue #28: Added ability for suffix and prefix text overflow
- Fixed Issue #16: Added support for RTL languages
- Fixed Issue #24: Version stability improvements
- Added `ImprovedAnimatedFlipCounter` widget with enhanced features
- Added comprehensive tests for all fixed issues

### Changed

- Removed external dependency on `animated_flip_counter` package
- Enhanced font rendering with additional font features
- Improved performance with better opacity handling
- Better clipping for smoother animations

### Fixed

- Font rendering issues with improved baseline handling
- Text overflow issues for prefix and suffix text
- RTL language support with proper text direction handling
- Animation stability issues from version 0.3.2

## [1.0.1] - 2024-01-15

### Changed

- Updated homepage URL to point to the official GitHub repository
- Minor documentation improvements

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
