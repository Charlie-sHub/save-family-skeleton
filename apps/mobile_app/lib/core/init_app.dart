import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sf_skeleton_app/app.dart';
import 'package:sf_skeleton_app/navigation/app_router.dart';
import 'package:navigation/navigation.dart';

enum EnvironmentEnum { development }

Future<void> initApp(EnvironmentEnum env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  navigationModule();
  themePackages();
  configureAppRouter();

  runApp(const ProviderScope(child: SFSkeletonApp()));
}
