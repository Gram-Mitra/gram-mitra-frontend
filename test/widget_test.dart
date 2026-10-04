import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gram_mitra/core/storage/storage_service.dart';
import 'package:gram_mitra/main.dart';
import 'package:gram_mitra/providers/app_state_provider.dart';
import 'package:gram_mitra/providers/auth_provider.dart';

void main() {
  testWidgets('Gram Mitra app launches smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ],
        child: const GramMitraApp(),
      ),
    );

    // Advance clock past the 1800ms splash delay
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump();

    expect(find.byType(GramMitraApp), findsOneWidget);
  });

  testWidgets('Dark mode toggle updates ThemeMode correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    final appState = AppStateProvider();
    expect(appState.isDarkMode, isFalse);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider.value(value: appState),
        ],
        child: const GramMitraApp(),
      ),
    );

    // Initial MaterialApp has ThemeMode.light
    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);

    // Toggle dark mode
    await appState.toggleDarkMode();
    await tester.pumpAndSettle();

    app = tester.widget(find.byType(MaterialApp));
    expect(appState.isDarkMode, isTrue);
    expect(app.themeMode, ThemeMode.dark);

    // Toggle back to light mode
    await appState.toggleDarkMode();
    await tester.pumpAndSettle();

    app = tester.widget(find.byType(MaterialApp));
    expect(appState.isDarkMode, isFalse);
    expect(app.themeMode, ThemeMode.light);
  });
}
