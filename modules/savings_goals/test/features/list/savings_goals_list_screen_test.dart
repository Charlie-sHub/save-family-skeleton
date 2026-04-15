import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localizations/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savings_goals/src/core/providers/savings_goals_preferences_provider.dart';
import 'package:savings_goals/src/features/list/savings_goals_list_screen.dart';

void main() {
  group('SavingsGoalsListScreen', () {
    testWidgets(
      'shows the error state for child-error and retry keeps the same path',
      (tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              themePortProvider.overrideWithValue(ThemeAdapter()),
              savingsGoalsPreferencesProvider.overrideWithValue(
                sharedPreferences,
              ),
            ],
            child: const MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.delegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SavingsGoalsListScreen(childId: 'child-error'),
            ),
          ),
        );

        await tester.pump();

        // Act
        await tester.pump(const Duration(milliseconds: 650));

        // Assert
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(
          find.text('Please check your connection and try again.'),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsOneWidget);

        // Act
        await tester.tap(find.text('Retry'));
        await tester.pump();

        // Assert
        expect(find.byType(LoadingIndicator), findsOneWidget);

        // Act
        await tester.pump(const Duration(milliseconds: 650));

        // Assert
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(
          find.text('Please check your connection and try again.'),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });
}
