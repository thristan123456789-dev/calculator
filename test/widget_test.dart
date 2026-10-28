import 'package:calculator/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator evaluates operations and handles division by zero', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('8'));
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    expect(find.text('8 +'), findsOneWidget);

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    expect(find.text('8 + 2'), findsOneWidget);
    expect(find.text('10'), findsNothing);

    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    expect(find.text('8 + 2 ='), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNWidgets(2));

    await tester.tap(find.text('8'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.text('0').last);
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsNWidgets(2));
  });

  testWidgets('calculator shows chained expressions without previewing answers',
      (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('8'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('×'));
    await tester.pumpAndSettle();

    expect(find.text('8 + 2 ×'), findsOneWidget);
    expect(find.text('10'), findsNothing);

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(find.text('8 + 2 × 3'), findsOneWidget);
    expect(find.text('30'), findsNothing);

    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    expect(find.text('8 + 2 × 3 ='), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });
}
