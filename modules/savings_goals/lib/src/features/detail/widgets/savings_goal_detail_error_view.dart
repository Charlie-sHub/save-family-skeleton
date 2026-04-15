import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

class SavingsGoalDetailErrorView extends StatelessWidget {
  const SavingsGoalDetailErrorView({
    required this.theme,
    required this.description,
    super.key,
  });

  final ThemePort theme;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        SizedBox(
          height: 420,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.translate(I18n.error),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.colorFor(ThemeCode.textPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: theme.colorFor(ThemeCode.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
