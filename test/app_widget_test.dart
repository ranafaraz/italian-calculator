import 'package:calcflow/app/calcflow_app.dart';
import 'package:calcflow/core/storage/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const CalcFlowApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pump();
}

void main() {
  testWidgets('loads in Italian and computes 7 + 8 = 15', (tester) async {
    await pumpApp(tester);

    expect(find.text('Calcolatrice'), findsOneWidget);
    expect(find.text('Convertitore'), findsOneWidget);

    await tapKey(tester, '7');
    await tapKey(tester, '+');
    await tapKey(tester, '8');

    // Live preview appears before equals is pressed.
    expect(find.text('= 15'), findsOneWidget);

    await tapKey(tester, '=');
    await tester.pumpAndSettle();
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('percentage follows calculator convention', (tester) async {
    await pumpApp(tester);

    for (final key in ['1', '0', '0', '−', '2', '5', '%', '=']) {
      await tapKey(tester, key);
    }
    await tester.pumpAndSettle();
    expect(find.text('75'), findsOneWidget);
  });

  testWidgets('scientific panel toggles and computes sqrt', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('SCI'));
    await tester.pumpAndSettle();
    expect(find.text('sin'), findsOneWidget);

    await tapKey(tester, '√');
    await tapKey(tester, '8');
    await tapKey(tester, '1');
    await tapKey(tester, '=');
    await tester.pumpAndSettle();
    expect(find.text('9'), findsWidgets);
  });

  testWidgets('division by zero shows friendly Italian error', (tester) async {
    await pumpApp(tester);

    for (final key in ['5', '÷', '0', '=']) {
      await tapKey(tester, key);
    }
    await tester.pumpAndSettle();
    expect(find.text('Impossibile dividere per zero'), findsOneWidget);
  });

  testWidgets('user can switch language to English in settings',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Impostazioni'), findsWidgets);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('Settings'), findsWidgets);
  });
}
