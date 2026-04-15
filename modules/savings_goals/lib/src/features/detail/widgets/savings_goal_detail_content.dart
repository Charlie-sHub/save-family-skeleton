import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

class SavingsGoalDetailContent extends StatelessWidget {
  const SavingsGoalDetailContent({
    required this.theme,
    required this.goal,
    required this.contributionController,
    required this.isSubmitting,
    required this.isSubmitEnabled,
    required this.onContributionChanged,
    required this.onSubmit,
    super.key,
  });

  final ThemePort theme;
  final SavingsGoal goal;
  final TextEditingController contributionController;
  final bool isSubmitting;
  final bool isSubmitEnabled;
  final ValueChanged<String> onContributionChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final progressPercent = (goal.progressRatio * 100).round();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
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
                Text(
                  goal.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: theme.colorFor(ThemeCode.textPrimary),
                  ),
                ),
                if (goal.description != null &&
                    goal.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    goal.description!,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: theme.colorFor(ThemeCode.textSecondary),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _AmountRow(
                  theme: theme,
                  label: context.translate(
                    I18n.savingsGoalsDetailCurrentAmountLabel,
                  ),
                  value: _currency(goal.currentAmount),
                ),
                const SizedBox(height: 12),
                _AmountRow(
                  theme: theme,
                  label: context.translate(
                    I18n.savingsGoalsDetailTargetAmountLabel,
                  ),
                  value: _currency(goal.targetAmount),
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
        ),
        const SizedBox(height: 24),
        SfTextInput(
          label: context.translate(I18n.savingsGoalsDetailContributionLabel),
          controller: contributionController,
          hintText: context.translate(I18n.savingsGoalsDetailContributionHint),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onContributionChanged,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: context.translate(I18n.savingsGoalsDetailSubmitLabel),
          onPressed: isSubmitEnabled ? () => onSubmit() : null,
          isLoading: isSubmitting,
        ),
      ],
    );
  }

  String _currency(double value) => '€${value.toStringAsFixed(2)}';
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.theme,
    required this.label,
    required this.value,
  });

  final ThemePort theme;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorFor(ThemeCode.textSecondary),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorFor(ThemeCode.textPrimary),
          ),
        ),
      ],
    );
  }
}
