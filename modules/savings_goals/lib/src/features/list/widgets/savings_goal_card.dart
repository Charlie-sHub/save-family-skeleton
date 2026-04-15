import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

const _deleteGoalTooltip = 'Delete goal';

class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({
    required this.goal,
    required this.theme,
    required this.onDelete,
    super.key,
  });

  final SavingsGoal goal;
  final ThemePort theme;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final progressPercent = (goal.progressRatio * 100).round();

    return Card(
      elevation: 0,
      color: theme.colorFor(ThemeCode.backgroundSecondary),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorFor(ThemeCode.border)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorFor(ThemeCode.textPrimary),
                        ),
                      ),
                      if (goal.description != null &&
                          goal.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          goal.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorFor(ThemeCode.textSecondary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: _deleteGoalTooltip,
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorFor(ThemeCode.error),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_currency(goal.currentAmount)} / ${_currency(goal.targetAmount)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorFor(ThemeCode.textPrimary),
                    ),
                  ),
                ),
                Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: theme.colorFor(ThemeCode.buttonPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: goal.progressRatio,
                minHeight: 10,
                color: theme.colorFor(ThemeCode.buttonPrimary),
                backgroundColor: theme.colorFor(ThemeCode.border),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _currency(double value) => '€${value.toStringAsFixed(2)}';
}
