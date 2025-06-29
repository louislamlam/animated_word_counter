import 'package:flutter/material.dart';
import 'package:animated_word_counter/animated_word_counter.dart';

void main() {
  runApp(const AnimatedWordCounterExampleApp());
}

class AnimatedWordCounterExampleApp extends StatelessWidget {
  const AnimatedWordCounterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Word Counter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WordCounterDemo(),
    );
  }
}

class WordCounterDemo extends StatefulWidget {
  const WordCounterDemo({super.key});

  @override
  State<WordCounterDemo> createState() => _WordCounterDemoState();
}

class _WordCounterDemoState extends State<WordCounterDemo> {
  final TextEditingController _textController = TextEditingController();
  WordCounterLanguage _selectedLanguage = WordCounterLanguage.auto;

  final Map<String, String> _demoTexts = {
    'English':
        'The quick brown fox jumps over the lazy dog. This demonstrates English word counting with punctuation, numbers like 123, and various sentence structures!',
    'Chinese': '这是一个中文文本示例，用于演示汉字计数功能。春天来了，花儿开放了，鸟儿在枝头歌唱。我们可以看到汉字是如何被正确计数的。',
    'Japanese':
        'これは日本語のテキストサンプルです。単語カウント機能をデモンストレーションします。春が来ました。桜の花が咲いています。ひらがな、カタカナ、漢字が混在しています。',
    'Korean':
        '이것은 한국어 텍스트 샘플입니다. 단어 계수 기능을 보여주기 위한 것입니다. 봄이 왔습니다. 꽃들이 피어났습니다. 한글의 아름다움을 느낄 수 있습니다.',
    'Arabic':
        'هذا نص تجريبي باللغة العربية لإظهار عد الكلمات والأحرف. الربيع قد حان والأزهار تتفتح في كل مكان. اللغة العربية لها جمال خاص.',
    'Mixed':
        'This is a mixed language text. 这包含中文。日本語も含まれています。한국어도 있습니다. مع بعض العربية. Beautiful multilingual content! 123 numbers too.',
  };

  @override
  void initState() {
    super.initState();
    _textController.text = _demoTexts['English']!;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Word Counter Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Language Selection Card
            _buildLanguageSelector(),

            const SizedBox(height: 16),

            // Demo Text Buttons
            _buildDemoTextButtons(),

            const SizedBox(height: 16),

            // Text Input Area
            _buildTextInput(),

            const SizedBox(height: 24),

            // Real-time Counter
            _buildRealTimeCounter(),

            const SizedBox(height: 16),

            // Different Styles Showcase
            _buildStyleShowcase(),

            const SizedBox(height: 16),

            // Advanced Features Demo
            _buildAdvancedFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Language Selection',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<WordCounterLanguage>(
                value: _selectedLanguage,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (WordCounterLanguage? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: WordCounterLanguage.values.map((language) {
                  final config = LanguageConfig.getConfig(language);
                  return DropdownMenuItem<WordCounterLanguage>(
                    value: language,
                    child: Text(config.name),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoTextButtons() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_snippet, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Sample Texts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _demoTexts.keys.map((language) {
                return ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _textController.text = _demoTexts[language]!;
                    });
                  },
                  icon: _getLanguageIcon(language),
                  label: Text(language),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Enter Your Text',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Type or paste your text here...',
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTimeCounter() {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.speed,
                    color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Real-time Word Counter',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            RealTimeAnimatedWordCounter(
              controller: _textController,
              language: _selectedLanguage,
              showStats: true,
              debounceDelay: const Duration(milliseconds: 300),
              textStyle: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 0,
                  height: 1),
              statsTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleShowcase() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Different Styles',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Minimalist Style
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Minimalist Style',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  SimpleAnimatedWordCounter(
                    text: _textController.text,
                    language: _selectedLanguage,
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                      height: 1,
                    ),
                    prefix: '',
                    suffix: ' words',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Colorful Style with Shadow
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Colorful Style',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 8),
                  AnimatedWordCounter(
                    text: _textController.text,
                    language: _selectedLanguage,
                    textStyle: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    prefix: '📝 ',
                    suffix: ' words',
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.bounceOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFeatures() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.auto_fix_high,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Advanced Features',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Text Overflow Demo
            _buildFeatureDemo(
              'Text Overflow Handling',
              ImprovedAnimatedFlipCounter(
                value: _textController.text.length,
                textStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, height: 1),
                prefix: 'Very long prefix that will be truncated: ',
                suffix: ' chars with long suffix',
                maxPrefixWidth: 120,
                maxSuffixWidth: 80,
                prefixOverflow: TextOverflow.ellipsis,
                suffixOverflow: TextOverflow.fade,
                improvedFontRendering: true,
              ),
            ),

            const SizedBox(height: 16),

            // RTL Support Demo
            _buildFeatureDemo(
              'RTL Language Support',
              Directionality(
                textDirection: TextDirection.rtl,
                child: ImprovedAnimatedFlipCounter(
                  value: _textController.text.split(' ').length,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, height: 1),
                  prefix: 'كلمات: ',
                  suffix: ' عدد',
                  supportRtl: true,
                  improvedFontRendering: true,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Improved Font Rendering
            _buildFeatureDemo(
              'Enhanced Font Rendering',
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Standard', style: TextStyle(fontSize: 12)),
                      ImprovedAnimatedFlipCounter(
                        value: 12345.67,
                        fractionDigits: 2,
                        textStyle: TextStyle(fontSize: 18, height: 1.4),
                        improvedFontRendering: false,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Enhanced', style: TextStyle(fontSize: 12)),
                      ImprovedAnimatedFlipCounter(
                        value: 12345.67,
                        fractionDigits: 2,
                        textStyle: TextStyle(fontSize: 18, height: 1.4),
                        improvedFontRendering: true,
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                          FontFeature.liningFigures(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureDemo(String title, Widget demo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Center(child: demo),
        ],
      ),
    );
  }

  Widget _getLanguageIcon(String language) {
    switch (language) {
      case 'English':
        return const Text('🇺🇸', style: TextStyle(fontSize: 16));
      case 'Chinese':
        return const Text('🇨🇳', style: TextStyle(fontSize: 16));
      case 'Japanese':
        return const Text('🇯🇵', style: TextStyle(fontSize: 16));
      case 'Korean':
        return const Text('🇰🇷', style: TextStyle(fontSize: 16));
      case 'Arabic':
        return const Text('🇸🇦', style: TextStyle(fontSize: 16));
      case 'Mixed':
        return const Text('🌍', style: TextStyle(fontSize: 16));
      default:
        return const Icon(Icons.text_fields, size: 16);
    }
  }
}
