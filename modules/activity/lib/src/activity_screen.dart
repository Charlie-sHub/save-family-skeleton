import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);

    return Scaffold(
      backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
      appBar: AppBar(
        title: Text(context.translate(I18n.activity)),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          context.translate(I18n.activityEmpty),
          style: TextStyle(
            fontSize: 16,
            color: theme.colorFor(ThemeCode.textSecondary),
          ),
        ),
      ),
    );
  }
}
