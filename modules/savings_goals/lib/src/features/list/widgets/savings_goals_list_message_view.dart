import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SavingsGoalsListMessageView extends StatelessWidget {
  const SavingsGoalsListMessageView({
    required this.theme,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final ThemePort theme;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
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
            const SizedBox(height: 24),
            PrimaryButton(
              label: actionLabel,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
