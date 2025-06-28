import 'package:flutter/material.dart';
import 'package:animated_word_counter/animated_word_counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Word Counter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Animated Word Counter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  WordCounterLanguage _selectedLanguage = WordCounterLanguage.auto;
  final Map<String, String> _sampleTexts = {
    'English':
        'The quick brown fox jumps over the lazy dog. This is a sample English text to demonstrate word counting.',
    'Chinese': '这是一个中文文本示例。用于演示汉字计数功能。春天来了，花儿开放了。',
    'Japanese': 'これは日本語のテキストサンプルです。単語カウント機能をデモンストレーションします。春が来ました。',
    'Korean': '이것은 한국어 텍스트 샘플입니다. 단어 계수 기능을 보여주기 위한 것입니다. 봄이 왔습니다.',
    'Thai': 'นี่คือตัวอย่างข้อความภาษาไทย เพื่อแสดงการนับคำ ฤดูใบไม้ผลิมาแล้ว',
    'Arabic': 'هذا نص تجريبي باللغة العربية لإظهار عد الكلمات. الربيع قد حان.',
    'Hebrew': 'זהו טקסט לדוגמה בעברית להדגמת ספירת מילים. האביב הגיע.',
    'Hindi':
        'यह हिंदी भाषा में एक नमूना पाठ है। शब्द गिनती सुविधा का प्रदर्शन करने के लिए।',
  };

  @override
  void initState() {
    super.initState();
    _controller.text = _sampleTexts['English']!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Language selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language Selection',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<WordCounterLanguage>(
                      value: _selectedLanguage,
                      isExpanded: true,
                      onChanged: (WordCounterLanguage? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                      items: WordCounterLanguage.values.map((language) {
                        final config = LanguageConfig.getConfig(language);
                        return DropdownMenuItem<WordCounterLanguage>(
                          value: language,
                          child: Text(
                              '${config.name} - ${config.description ?? ''}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sample text buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Texts',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _sampleTexts.keys.map((language) {
                        return ElevatedButton(
                          onPressed: () {
                            _controller.text = _sampleTexts[language]!;
                          },
                          child: Text(language),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Text input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your text:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your text here...',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Real-time counter with stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Real-time Word Counter',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    RealTimeAnimatedWordCounter(
                      controller: _controller,
                      language: _selectedLanguage,
                      showStats: true,
                      textStyle: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      statsTextStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Different styling examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Different Styles',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Simple counter
                    SimpleAnimatedWordCounter(
                      text: _controller.text,
                      language: _selectedLanguage,
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Colors.blue,
                      ),
                      prefix: '📝 ',
                      suffix: ' words',
                    ),

                    const SizedBox(height: 16),

                    // Styled counter with shadow
                    AnimatedWordCounter(
                      text: _controller.text,
                      language: _selectedLanguage,
                      textStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        shadows: [
                          Shadow(
                            color: Colors.orange.withOpacity(0.3),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      prefix: 'Count: ',
                      suffix: '',
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.bounceOut,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // New: Showcase fixed issues
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Fixed Issues Demo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Issue #28: Text overflow support
                    Text(
                      'Text Overflow Support (Issue #28):',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    ImprovedAnimatedFlipCounter(
                      value: _controller.text.length,
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      prefix: 'Very long prefix text that might overflow: ',
                      suffix: ' characters with long suffix text',
                      maxPrefixWidth: 100,
                      maxSuffixWidth: 80,
                      prefixOverflow: TextOverflow.ellipsis,
                      suffixOverflow: TextOverflow.fade,
                      improvedFontRendering: true,
                    ),

                    const SizedBox(height: 16),

                    // Issue #16: RTL support
                    Text(
                      'RTL Language Support (Issue #16):',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ImprovedAnimatedFlipCounter(
                        value: _controller.text.split(' ').length,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                        prefix: 'كلمات: ',
                        suffix: ' عدد',
                        supportRtl: true,
                        improvedFontRendering: true,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Issue #30: Improved font rendering
                    Text(
                      'Improved Font Rendering (Issue #30):',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('Standard'),
                            ImprovedAnimatedFlipCounter(
                              value: 12345.67,
                              fractionDigits: 2,
                              textStyle: const TextStyle(fontSize: 20),
                              improvedFontRendering: false,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Improved'),
                            ImprovedAnimatedFlipCounter(
                              value: 12345.67,
                              fractionDigits: 2,
                              textStyle: const TextStyle(fontSize: 20),
                              improvedFontRendering: true,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                                FontFeature.liningFigures(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
