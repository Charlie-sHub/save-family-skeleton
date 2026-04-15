import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

class CreateSavingsGoalForm extends StatelessWidget {
  const CreateSavingsGoalForm({
    required this.nameErrorText,
    required this.targetAmountErrorText,
    required this.descriptionErrorText,
    required this.isSubmitting,
    required this.isSubmitEnabled,
    required this.onNameChanged,
    required this.onTargetAmountChanged,
    required this.onDescriptionChanged,
    required this.onSubmit,
    super.key,
  });

  final String? nameErrorText;
  final String? targetAmountErrorText;
  final String? descriptionErrorText;
  final bool isSubmitting;
  final bool isSubmitEnabled;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onTargetAmountChanged;
  final ValueChanged<String> onDescriptionChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SfTextInput(
          label: context.translate(I18n.savingsGoalsCreateNameLabel),
          hintText: context.translate(I18n.savingsGoalsCreateNameHint),
          errorText: nameErrorText,
          maxLength: 40,
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 16),
        SfTextInput(
          label: context.translate(I18n.savingsGoalsCreateTargetAmountLabel),
          hintText: context.translate(I18n.savingsGoalsCreateTargetAmountHint),
          errorText: targetAmountErrorText,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onTargetAmountChanged,
        ),
        const SizedBox(height: 16),
        SfTextInput(
          label: context.translate(I18n.savingsGoalsCreateDescriptionLabel),
          hintText: context.translate(I18n.savingsGoalsCreateDescriptionHint),
          errorText: descriptionErrorText,
          maxLength: 200,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: context.translate(I18n.savingsGoalsCreateSubmitLabel),
          onPressed: isSubmitting || !isSubmitEnabled ? null : () => onSubmit(),
          isLoading: isSubmitting,
        ),
      ],
    );
  }
}
