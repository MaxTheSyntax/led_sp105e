import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:led_sp105e/main.dart';

void main() {
  testWidgets('App starts with home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('SP105E LED Controller'), findsOneWidget);
    
    // Verify that the available devices section is present
    expect(find.text('Available Devices'), findsOneWidget);
  });
}
