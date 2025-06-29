import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_word_counter/animated_word_counter.dart';

void main() {
  group('ImprovedAnimatedFlipCounter', () {
    testWidgets('renders basic counter correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImprovedAnimatedFlipCounter(value: 42),
          ),
        ),
      );

      expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
    });

    testWidgets('supports negative values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImprovedAnimatedFlipCounter(value: -42),
          ),
        ),
      );

      // Should show negative sign
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('supports decimal values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImprovedAnimatedFlipCounter(
              value: 42.5,
              fractionDigits: 1,
            ),
          ),
        ),
      );

      expect(find.text('.'), findsOneWidget);
    });

    testWidgets('supports prefix and suffix', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImprovedAnimatedFlipCounter(
              value: 42,
              prefix: '\$',
              suffix: ' USD',
            ),
          ),
        ),
      );

      expect(find.text('\$'), findsOneWidget);
      expect(find.text(' USD'), findsOneWidget);
    });

    testWidgets('supports thousand separator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImprovedAnimatedFlipCounter(
              value: 1000,
              thousandSeparator: ',',
            ),
          ),
        ),
      );

      expect(find.text(','), findsOneWidget);
    });

    group('Fixed Issues', () {
      // Test for Issue #28: Add ability for suffix textOverflow
      testWidgets('supports suffix text overflow (Issue #28)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(
                value: 42,
                suffix: 'Very long suffix text that should overflow',
                maxSuffixWidth: 50,
                suffixOverflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
      });

      // Test for Issue #16: Support for RTL languages
      testWidgets('supports RTL text direction (Issue #16)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: ImprovedAnimatedFlipCounter(
                  value: 42,
                  prefix: 'عدد: ',
                  suffix: ' كلمة',
                  supportRtl: true,
                ),
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
        expect(find.text('عدد: '), findsOneWidget);
        expect(find.text(' كلمة'), findsOneWidget);
      });

      // Test for Issue #30: Weird font rendering
      testWidgets('supports improved font rendering (Issue #30)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(
                value: 42,
                improvedFontRendering: true,
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
      });

      // Test for custom font features
      testWidgets('supports custom font features', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(
                value: 42,
                improvedFontRendering: true,
                fontFeatures: [
                  FontFeature.tabularFigures(),
                  FontFeature.liningFigures(),
                ],
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
      });

      // Test for prefix overflow
      testWidgets('supports prefix text overflow', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(
                value: 42,
                prefix: 'Very long prefix text that should overflow',
                maxPrefixWidth: 50,
                prefixOverflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
      });
    });

    group('Animation', () {
      testWidgets('animates value changes', (WidgetTester tester) async {
        int value = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      ImprovedAnimatedFlipCounter(
                        value: value,
                        duration: const Duration(milliseconds: 100),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => value++),
                        child: const Text('Increment'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('0'), findsOneWidget);

        // Tap increment button
        await tester.tap(find.text('Increment'));
        await tester.pump();

        // Start animation
        await tester.pump(const Duration(milliseconds: 50));

        // Complete animation
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('1'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles zero value', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(value: 0),
            ),
          ),
        );

        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('handles very large numbers', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(
                value: 9999999,
                thousandSeparator: ',',
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
      });

      testWidgets('handles decimal precision edge cases',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImprovedAnimatedFlipCounter(
                value: 0.999,
                fractionDigits: 2,
              ),
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(ImprovedAnimatedFlipCounter), findsOneWidget);
      });
    });
  });
}
