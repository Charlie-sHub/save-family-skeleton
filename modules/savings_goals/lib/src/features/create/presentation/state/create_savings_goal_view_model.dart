import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/domain/entities/create_savings_goal_request.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/providers/savings_goals_repository_provider.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_state.dart';

final createSavingsGoalViewModelProvider = NotifierProvider.autoDispose
    .family<CreateSavingsGoalViewModel, CreateSavingsGoalViewState, String>(
      CreateSavingsGoalViewModel.new,
    );

class CreateSavingsGoalViewModel extends Notifier<CreateSavingsGoalViewState> {
  CreateSavingsGoalViewModel(this.childId);

  final String childId;

  @override
  CreateSavingsGoalViewState build() =>
      CreateSavingsGoalViewState.initial(childId: childId);

  void updateName(String value) => _updateForm(name: value);

  void updateTargetAmount(String value) => _updateForm(targetAmount: value);

  void updateDescription(String value) => _updateForm(description: value);

  Future<void> submit() async {
    final validation = _validateForm(
      name: state.name,
      targetAmount: state.targetAmount,
      description: state.description,
    );

    state = state.copyWith(
      nameValidationError: validation.nameValidationError,
      targetAmountValidationError: validation.targetAmountValidationError,
      descriptionValidationError: validation.descriptionValidationError,
      isValid: validation.isValid,
      errorMessage: null,
      errorEvent: null,
      successEvent: null,
    );

    if (!validation.isValid || validation.parsedTargetAmount == null) {
      return;
    } else {
      state = state.copyWith(isSubmitting: true);
    }

    try {
      await ref
          .read(savingsGoalsRepositoryProvider)
          .createGoal(
            childId,
            CreateSavingsGoalRequest(
              name: validation.trimmedName,
              targetAmount: validation.parsedTargetAmount!,
              description: validation.trimmedDescription.isEmpty
                  ? null
                  : validation.trimmedDescription,
            ),
          );

      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: null,
          errorEvent: null,
          successEvent: CreateSavingsGoalSuccessEvent.goalCreated,
        );
      }
    } on SavingsGoalsFailure catch (failure) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: switch (failure) {
            SavingsGoalsDuplicateNameConflictFailure(:final message) => message,
            _ => null,
          },
          errorEvent: CreateSavingsGoalErrorEvent.submitFailed,
          successEvent: null,
        );
      }
    } catch (_) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: null,
          errorEvent: CreateSavingsGoalErrorEvent.submitFailed,
          successEvent: null,
        );
      }
    }
  }

  void clearEvents() => state = state.copyWith(
    errorMessage: null,
    errorEvent: null,
    successEvent: null,
  );

  void _updateForm({String? name, String? targetAmount, String? description}) {
    final nextName = name ?? state.name;
    final nextTargetAmount = targetAmount ?? state.targetAmount;
    final nextDescription = description ?? state.description;
    final validation = _validateForm(
      name: nextName,
      targetAmount: nextTargetAmount,
      description: nextDescription,
    );

    state = state.copyWith(
      name: nextName,
      targetAmount: nextTargetAmount,
      description: nextDescription,
      nameValidationError: validation.nameValidationError,
      targetAmountValidationError: validation.targetAmountValidationError,
      descriptionValidationError: validation.descriptionValidationError,
      isValid: validation.isValid,
    );
  }

  ({
    String trimmedName,
    String trimmedDescription,
    double? parsedTargetAmount,
    CreateSavingsGoalNameValidationError? nameValidationError,
    CreateSavingsGoalTargetAmountValidationError? targetAmountValidationError,
    CreateSavingsGoalDescriptionValidationError? descriptionValidationError,
    bool isValid,
  })
  _validateForm({
    required String name,
    required String targetAmount,
    required String description,
  }) {
    final trimmedName = name.trim();
    final trimmedTargetAmount = targetAmount.trim();
    final trimmedDescription = description.trim();
    final parsedTargetAmount = double.tryParse(trimmedTargetAmount);
    final nameValidationError = _validateName(trimmedName);
    final targetAmountValidationError = _validateTargetAmount(
      trimmedTargetAmount,
      parsedTargetAmount,
    );
    final descriptionValidationError = _validateDescription(trimmedDescription);
    final isValid =
        nameValidationError == null &&
        targetAmountValidationError == null &&
        descriptionValidationError == null;

    return (
      trimmedName: trimmedName,
      trimmedDescription: trimmedDescription,
      parsedTargetAmount: parsedTargetAmount,
      nameValidationError: nameValidationError,
      targetAmountValidationError: targetAmountValidationError,
      descriptionValidationError: descriptionValidationError,
      isValid: isValid,
    );
  }

  CreateSavingsGoalNameValidationError? _validateName(String trimmedValue) {
    if (trimmedValue.isEmpty) {
      return CreateSavingsGoalNameValidationError.required;
    } else if (trimmedValue.length < 3) {
      return CreateSavingsGoalNameValidationError.tooShort;
    } else if (trimmedValue.length > 40) {
      return CreateSavingsGoalNameValidationError.tooLong;
    } else {
      return null;
    }
  }

  CreateSavingsGoalTargetAmountValidationError? _validateTargetAmount(
    String trimmedValue,
    double? parsedValue,
  ) {
    if (trimmedValue.isEmpty) {
      return CreateSavingsGoalTargetAmountValidationError.required;
    } else if (parsedValue == null) {
      return CreateSavingsGoalTargetAmountValidationError.invalid;
    } else if (parsedValue <= 0) {
      return CreateSavingsGoalTargetAmountValidationError.mustBeGreaterThanZero;
    } else if (parsedValue > 10000) {
      return CreateSavingsGoalTargetAmountValidationError.tooHigh;
    } else {
      return null;
    }
  }

  CreateSavingsGoalDescriptionValidationError? _validateDescription(
    String trimmedValue,
  ) {
    if (trimmedValue.isEmpty) {
      return null;
    } else if (trimmedValue.length > 200) {
      return CreateSavingsGoalDescriptionValidationError.tooLong;
    } else {
      return null;
    }
  }
}
