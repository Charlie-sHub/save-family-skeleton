import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

const _nameLabel = 'Name';
const _nameHint = 'Enter a goal name';
const _targetAmountLabel = 'Target amount';
const _targetAmountHint = 'Enter the target amount';
const _descriptionLabel = 'Description';
const _descriptionHint = 'Add an optional description';
const _submitLabel = 'Create goal';

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
          label: _nameLabel,
          hintText: _nameHint,
          errorText: nameErrorText,
          maxLength: 40,
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 16),
        SfTextInput(
          label: _targetAmountLabel,
          hintText: _targetAmountHint,
          errorText: targetAmountErrorText,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onTargetAmountChanged,
        ),
        const SizedBox(height: 16),
        SfTextInput(
          label: _descriptionLabel,
          hintText: _descriptionHint,
          errorText: descriptionErrorText,
          maxLength: 200,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: _submitLabel,
          onPressed: isSubmitting || !isSubmitEnabled ? null : () => onSubmit(),
          isLoading: isSubmitting,
        ),
      ],
    );
  }
}
