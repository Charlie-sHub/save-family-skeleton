import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localizations/localizations.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_model.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_state.dart';
import 'package:savings_goals/src/features/create/widgets/create_savings_goal_form.dart';

class CreateSavingsGoalScreen extends ConsumerWidget {
  const CreateSavingsGoalScreen({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = createSavingsGoalViewModelProvider(childId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final theme = ref.watch(themePortProvider);

    ref.listen<CreateSavingsGoalViewState>(provider, (previous, next) {
      if (next.errorEvent == null && next.successEvent == null) {
        return;
      } else {
        final messenger = ScaffoldMessenger.of(context);
        final message = _snackBarMessage(context, next);

        if (message != null) {
          messenger.hideCurrentSnackBar();
        }

        if (next.successEvent == CreateSavingsGoalSuccessEvent.goalCreated) {
          viewModel.clearEvents();
          context.pop(true);

          if (message != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (message != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 2),
              ),
            );
          }

          viewModel.clearEvents();
        }
      }
    });

    return Scaffold(
      key: ValueKey<String>('create_savings_goal_screen_${state.childId}'),
      backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
      appBar: AppBar(
        title: Text(context.translate(I18n.savingsGoalsCreateTitle)),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: CreateSavingsGoalForm(
          nameErrorText: _nameValidationMessage(
            context,
            state.nameValidationError,
          ),
          targetAmountErrorText: _targetAmountValidationMessage(
            context,
            state.targetAmountValidationError,
          ),
          descriptionErrorText: _descriptionValidationMessage(
            context,
            state.descriptionValidationError,
          ),
          isSubmitting: state.isSubmitting,
          isSubmitEnabled: state.isValid,
          onNameChanged: viewModel.updateName,
          onTargetAmountChanged: viewModel.updateTargetAmount,
          onDescriptionChanged: viewModel.updateDescription,
          onSubmit: viewModel.submit,
        ),
      ),
    );
  }

  String? _snackBarMessage(
    BuildContext context,
    CreateSavingsGoalViewState state,
  ) {
    switch (state.successEvent) {
      case CreateSavingsGoalSuccessEvent.goalCreated:
        return context.translate(I18n.savingsGoalsCreateSuccessMessage);
      case null:
        break;
    }

    switch (state.errorEvent) {
      case CreateSavingsGoalErrorEvent.submitFailed:
        return state.errorMessage ??
            context.translate(I18n.savingsGoalsCreateSubmitFailure);
      case null:
        break;
    }

    return null;
  }

  String? _nameValidationMessage(
    BuildContext context,
    CreateSavingsGoalNameValidationError? validationError,
  ) {
    switch (validationError) {
      case CreateSavingsGoalNameValidationError.required:
        return context.translate(I18n.savingsGoalsCreateNameRequired);
      case CreateSavingsGoalNameValidationError.tooShort:
        return context.translate(I18n.savingsGoalsCreateNameTooShort);
      case CreateSavingsGoalNameValidationError.tooLong:
        return context.translate(I18n.savingsGoalsCreateNameTooLong);
      case null:
        return null;
    }
  }

  String? _targetAmountValidationMessage(
    BuildContext context,
    CreateSavingsGoalTargetAmountValidationError? validationError,
  ) {
    switch (validationError) {
      case CreateSavingsGoalTargetAmountValidationError.required:
        return context.translate(I18n.savingsGoalsCreateTargetAmountRequired);
      case CreateSavingsGoalTargetAmountValidationError.invalid:
        return context.translate(I18n.savingsGoalsCreateTargetAmountInvalid);
      case CreateSavingsGoalTargetAmountValidationError.mustBeGreaterThanZero:
        return context.translate(
          I18n.savingsGoalsCreateTargetAmountMustBeGreaterThanZero,
        );
      case CreateSavingsGoalTargetAmountValidationError.tooHigh:
        return context.translate(I18n.savingsGoalsCreateTargetAmountTooHigh);
      case null:
        return null;
    }
  }

  String? _descriptionValidationMessage(
    BuildContext context,
    CreateSavingsGoalDescriptionValidationError? validationError,
  ) {
    switch (validationError) {
      case CreateSavingsGoalDescriptionValidationError.tooLong:
        return context.translate(I18n.savingsGoalsCreateDescriptionTooLong);
      case null:
        return null;
    }
  }
}
