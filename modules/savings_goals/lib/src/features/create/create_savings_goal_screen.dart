import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_model.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_state.dart';
import 'package:savings_goals/src/features/create/widgets/create_savings_goal_form.dart';

const _screenTitle = 'New savings goal';
const _successMessage = 'Savings goal created.';
const _submitFailureFallback = 'We could not create the savings goal.';
const _nameRequiredMessage = 'Please enter a name.';
const _nameTooShortMessage = 'Name must be at least 3 characters.';
const _nameTooLongMessage = 'Name must be at most 40 characters.';
const _targetAmountRequiredMessage = 'Please enter a target amount.';
const _targetAmountInvalidMessage = 'Enter a valid amount.';
const _targetAmountMustBeGreaterThanZeroMessage =
    'Amount must be greater than 0.';
const _targetAmountTooHighMessage = 'Amount must be 10000 or less.';
const _descriptionTooLongMessage =
    'Description must be at most 200 characters.';

class CreateSavingsGoalScreen extends ConsumerWidget {
  const CreateSavingsGoalScreen({
    required this.childId,
    super.key,
  });

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
        final message = _snackBarMessage(next);

        if (message != null) {
          messenger.hideCurrentSnackBar();
        }

        if (next.successEvent == CreateSavingsGoalSuccessEvent.goalCreated) {
          viewModel.clearEvents();
          context.pop();

          if (message != null) {
            messenger.showSnackBar(
              const SnackBar(
                content: Text(_successMessage),
                duration: Duration(seconds: 2),
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
        title: const Text(_screenTitle),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: CreateSavingsGoalForm(
          nameErrorText: _nameValidationMessage(state.nameValidationError),
          targetAmountErrorText: _targetAmountValidationMessage(
            state.targetAmountValidationError,
          ),
          descriptionErrorText: _descriptionValidationMessage(
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

  String? _snackBarMessage(CreateSavingsGoalViewState state) {
    switch (state.successEvent) {
      case CreateSavingsGoalSuccessEvent.goalCreated:
        return _successMessage;
      case null:
        break;
    }

    switch (state.errorEvent) {
      case CreateSavingsGoalErrorEvent.submitFailed:
        return state.errorMessage ?? _submitFailureFallback;
      case null:
        break;
    }

    return null;
  }

  String? _nameValidationMessage(
    CreateSavingsGoalNameValidationError? validationError,
  ) {
    switch (validationError) {
      case CreateSavingsGoalNameValidationError.required:
        return _nameRequiredMessage;
      case CreateSavingsGoalNameValidationError.tooShort:
        return _nameTooShortMessage;
      case CreateSavingsGoalNameValidationError.tooLong:
        return _nameTooLongMessage;
      case null:
        return null;
    }
  }

  String? _targetAmountValidationMessage(
    CreateSavingsGoalTargetAmountValidationError? validationError,
  ) {
    switch (validationError) {
      case CreateSavingsGoalTargetAmountValidationError.required:
        return _targetAmountRequiredMessage;
      case CreateSavingsGoalTargetAmountValidationError.invalid:
        return _targetAmountInvalidMessage;
      case CreateSavingsGoalTargetAmountValidationError.mustBeGreaterThanZero:
        return _targetAmountMustBeGreaterThanZeroMessage;
      case CreateSavingsGoalTargetAmountValidationError.tooHigh:
        return _targetAmountTooHighMessage;
      case null:
        return null;
    }
  }

  String? _descriptionValidationMessage(
    CreateSavingsGoalDescriptionValidationError? validationError,
  ) {
    switch (validationError) {
      case CreateSavingsGoalDescriptionValidationError.tooLong:
        return _descriptionTooLongMessage;
      case null:
        return null;
    }
  }
}
