import 'package:design_system/src/theme/theme_module.dart';
import 'package:design_system/src/theme/theme_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingIndicator extends ConsumerWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);
    return Center(
      child: CircularProgressIndicator(
        color: theme.colorFor(ThemeCode.buttonPrimary),
      ),
    );
  }
}
