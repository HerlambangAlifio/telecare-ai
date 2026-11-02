// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:telehalth_aplikasi/main.dart';

void main() {
  testWidgets('Bottom navigation switches between home and consultation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TeleCareApp());

    expect(find.text('TeleCare AI'), findsOneWidget);
    expect(find.text('Konsultasi dengan Asisten AI'), findsOneWidget);
    expect(find.text('Konsultasi Dokter'), findsOneWidget);

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(find.text('Pilih jenis konsultasi'), findsOneWidget);
    expect(find.text('Konsultasi dengan Asisten AI'), findsOneWidget);

    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();

    expect(
      find.text('Konsultasi Kesehatan Lebih Mudah dari Mana Saja'),
      findsOneWidget,
    );
  });
}
