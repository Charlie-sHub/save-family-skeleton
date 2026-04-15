import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

class HomeChildSummaryCard extends StatelessWidget {
  const HomeChildSummaryCard({
    required this.childName,
    required this.goalsCount,
    required this.totalCurrentAmount,
    required this.totalTargetAmount,
    required this.onTap,
    required this.theme,
    super.key,
  });

  final String childName;
  final int goalsCount;
  final double totalCurrentAmount;
  final double totalTargetAmount;
  final VoidCallback onTap;
  final ThemePort theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorFor(ThemeCode.backgroundSecondary),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      childName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: theme.colorFor(ThemeCode.textPrimary),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorFor(ThemeCode.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 18,
                    color: theme.colorFor(ThemeCode.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _summaryText(context),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorFor(ThemeCode.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return '€${amount.toStringAsFixed(0)}';
    } else {
      return '€${amount.toStringAsFixed(2)}';
    }
  }

  String _summaryText(BuildContext context) {
    final summaryKey = goalsCount == 1
        ? I18n.homeChildSummarySingleGoal
        : I18n.homeChildSummaryMultipleGoals;

    return context.translate(
      summaryKey,
      args: {
        'goalsCount': '$goalsCount',
        'currentAmount': _formatAmount(totalCurrentAmount),
        'targetAmount': _formatAmount(totalTargetAmount),
      },
    );
  }
}
