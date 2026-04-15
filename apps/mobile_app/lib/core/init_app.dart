import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savings_goals/savings_goals.dart';
import 'package:sf_skeleton_app/app.dart';
import 'package:sf_skeleton_app/navigation/app_router.dart';

enum EnvironmentEnum { development }

Future<void> initApp(EnvironmentEnum env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final sharedPreferences = await SharedPreferences.getInstance();

  navigationModule();
  themePackages();
  configureAppRouter();

  runApp(
    ProviderScope(
      overrides: [
        savingsGoalsPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const SFSkeletonApp(),
    ),
  );
}
