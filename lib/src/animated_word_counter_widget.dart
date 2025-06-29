import 'dart:async';

import 'package:flutter/material.dart';

import 'improved_animated_flip_counter.dart';
import 'language_aware_word_counter.dart';
import 'word_counter_languages.dart';

/// An animated word counter widget that displays word count with smooth animations
class AnimatedWordCounter extends StatefulWidget {
  const AnimatedWordCounter({
    super.key,
    required this.text,
    this.language = WordCounterLanguage.auto,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.textStyle,
    this.prefix = '',
    this.suffix = ' words',
    this.fractionDigits = 0,
    this.thousandSeparator = ',',
    this.onCountChanged,
    this.showStats = false,
    this.statsTextStyle,
    this.counterAlignment = MainAxisAlignment.center,
    this.statsAlignment = MainAxisAlignment.center,
  });

  /// The text to count words from
  final String text;

  /// The language to use for word counting
  final WordCounterLanguage language;

  /// Duration of the flip animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Text style for the counter
  final TextStyle? textStyle;

  /// Text to show before the counter
  final String prefix;

  /// Text to show after the counter
  final String suffix;

  /// Number of decimal places (usually 0 for word counts)
  final int fractionDigits;

  /// Thousand separator character
  final String thousandSeparator;

  /// Callback when the word count changes
  final ValueChanged<WordCountStats>? onCountChanged;

  /// Whether to show additional statistics
  final bool showStats;

  /// Text style for the statistics
  final TextStyle? statsTextStyle;

  /// Alignment for the counter
  final MainAxisAlignment counterAlignment;

  /// Alignment for the statistics
  final MainAxisAlignment statsAlignment;

  @override
  State<AnimatedWordCounter> createState() => _AnimatedWordCounterState();
}

class _AnimatedWordCounterState extends State<AnimatedWordCounter> {
  late LanguageAwareWordCounter _counter;
  WordCountStats? _stats;

  @override
  void initState() {
    super.initState();
    _counter = LanguageAwareWordCounter(language: widget.language);
    _updateStats();
  }

  @override
  void didUpdateWidget(AnimatedWordCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.language != widget.language) {
      _counter = LanguageAwareWordCounter(language: widget.language);
    }

    if (oldWidget.text != widget.text ||
        oldWidget.language != widget.language) {
      _updateStats();
    }
  }

  void _updateStats() {
    final newStats = _counter.getStats(widget.text);
    if (_stats == null ||
        _stats!.wordCount != newStats.wordCount ||
        _stats!.characterCount != newStats.characterCount) {
      setState(() {
        _stats = newStats;
      });
      widget.onCountChanged?.call(_stats!);
    } else {
      _stats = newStats;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_stats == null) {
      return const SizedBox.shrink(); // Return empty widget if stats not ready
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main counter
        Row(
          mainAxisAlignment: widget.counterAlignment,
          children: [
            ImprovedAnimatedFlipCounter(
              value: _stats!.wordCount,
              duration: widget.duration,
              curve: widget.curve,
              textStyle: widget.textStyle ?? _defaultTextStyle(context),
              prefix: widget.prefix,
              suffix: widget.suffix,
              fractionDigits: widget.fractionDigits,
              thousandSeparator: widget.thousandSeparator,
              improvedFontRendering: true,
              supportRtl: true, // Enable RTL support
            ),
          ],
        ),

        // Additional statistics
        if (widget.showStats) ...[
          const SizedBox(height: 8),
          _buildStatsRow(context),
        ],
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final stats = _stats!; // Safe to use ! since build method checks for null
    final defaultStatsStyle =
        widget.statsTextStyle ?? _defaultStatsTextStyle(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 4,
      children: [
        _buildStatItem(
          'Characters: ${stats.characterCount}',
          defaultStatsStyle,
        ),
        _buildStatItem(
          'Characters (no spaces): ${stats.characterCountNoSpaces}',
          defaultStatsStyle,
        ),
        _buildStatItem(
          'Lines: ${stats.lineCount}',
          defaultStatsStyle,
        ),
        if (stats.paragraphCount > 1)
          _buildStatItem(
            'Paragraphs: ${stats.paragraphCount}',
            defaultStatsStyle,
          ),
        _buildStatItem(
          'Language: ${_counter.config.name}',
          defaultStatsStyle,
        ),
      ],
    );
  }

  Widget _buildStatItem(String text, TextStyle style) {
    return Text(text, style: style);
  }

  TextStyle _defaultTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium ??
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  }

  TextStyle _defaultStatsTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall ??
        const TextStyle(fontSize: 12, color: Colors.grey);
  }
}

/// A simplified animated word counter that just shows the count
class SimpleAnimatedWordCounter extends StatelessWidget {
  const SimpleAnimatedWordCounter({
    super.key,
    required this.text,
    this.language = WordCounterLanguage.auto,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.textStyle,
    this.prefix = '',
    this.suffix = '',
  });

  final String text;
  final WordCounterLanguage language;
  final Duration duration;
  final Curve curve;
  final TextStyle? textStyle;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final counter = LanguageAwareWordCounter(language: language);
    final wordCount = counter.countWords(text);

    return ImprovedAnimatedFlipCounter(
      value: wordCount,
      duration: duration,
      curve: curve,
      textStyle: textStyle,
      prefix: prefix,
      suffix: suffix,
      fractionDigits: 0,
      improvedFontRendering: true,
      supportRtl: true, // Enable RTL support
    );
  }
}

/// A word counter that updates in real-time as the user types
class RealTimeAnimatedWordCounter extends StatefulWidget {
  const RealTimeAnimatedWordCounter({
    super.key,
    required this.controller,
    this.language = WordCounterLanguage.auto,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.textStyle,
    this.prefix = '',
    this.suffix = ' words',
    this.showStats = false,
    this.statsTextStyle,
    this.debounceDelay = const Duration(milliseconds: 100),
  });

  /// Text editing controller to listen to
  final TextEditingController controller;

  /// The language to use for word counting
  final WordCounterLanguage language;

  /// Duration of the flip animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Text style for the counter
  final TextStyle? textStyle;

  /// Text to show before the counter
  final String prefix;

  /// Text to show after the counter
  final String suffix;

  /// Whether to show additional statistics
  final bool showStats;

  /// Text style for the statistics
  final TextStyle? statsTextStyle;

  /// Delay before updating the counter to avoid excessive updates
  final Duration debounceDelay;

  @override
  State<RealTimeAnimatedWordCounter> createState() =>
      _RealTimeAnimatedWordCounterState();
}

class _RealTimeAnimatedWordCounterState
    extends State<RealTimeAnimatedWordCounter> {
  late String _text;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _text = widget.controller.text;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay, () {
      if (mounted && _text != widget.controller.text) {
        setState(() {
          _text = widget.controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedWordCounter(
      text: _text,
      language: widget.language,
      duration: widget.duration,
      curve: widget.curve,
      textStyle: widget.textStyle,
      prefix: widget.prefix,
      suffix: widget.suffix,
      showStats: widget.showStats,
      statsTextStyle: widget.statsTextStyle,
    );
  }
}
