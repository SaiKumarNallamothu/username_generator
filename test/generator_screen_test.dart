import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:username_generator/screens/generator_screen.dart';
import 'package:username_generator/services/storage_service.dart';
import 'package:username_generator/theme/custom_theme.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final tempDir = Directory.systemTemp.createTempSync('hive_test');
    await StorageService.init(tempDir.path);
  });

  testWidgets('GeneratorScreen renders correctly with tabs and input field', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CustomTheme.darkTheme,
        home: const ProviderScope(
          child: GeneratorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify app title and tabs are rendered
    expect(find.text('GAMING STUDIO'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);
    expect(find.text('Builder'), findsOneWidget);
    expect(find.text('AI Ideas'), findsOneWidget);
    expect(find.text('Clan Tags'), findsOneWidget);
    expect(find.text('Bio & Colors'), findsOneWidget);
    expect(find.text('Roller'), findsOneWidget);
    expect(find.text('Symbols'), findsOneWidget);
  });
}
