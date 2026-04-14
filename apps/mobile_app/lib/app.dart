import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sf_skeleton_app/navigation/app_router.dart';
import 'package:localizations/localizations.dart';

class SFSkeletonApp extends ConsumerWidget {
  const SFSkeletonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SaveFamily',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A6CF7)),
      ),
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
