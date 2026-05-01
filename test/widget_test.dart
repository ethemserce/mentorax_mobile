import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/app/mentorax_app.dart';

void main() {
  testWidgets('MentoraX app renders splash state', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MentoraXApp()));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
