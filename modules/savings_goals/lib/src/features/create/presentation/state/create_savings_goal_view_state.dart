import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_savings_goal_view_state.freezed.dart';

enum CreateSavingsGoalErrorEvent { submitFailed }

enum CreateSavingsGoalSuccessEvent { goalCreated }

enum CreateSavingsGoalNameValidationError { required, tooShort, tooLong }

enum CreateSavingsGoalTargetAmountValidationError {
  required,
  invalid,
  mustBeGreaterThanZero,
  tooHigh,
}

enum CreateSavingsGoalDescriptionValidationError { tooLong }

@freezed
abstract class CreateSavingsGoalViewState with _$CreateSavingsGoalViewState {
  factory CreateSavingsGoalViewState.initial({required String childId}) =>
      CreateSavingsGoalViewState(childId: childId);

  const factory CreateSavingsGoalViewState({
    required String childId,
    @Default('') String name,
    @Default('') String targetAmount,
    @Default('') String description,
    CreateSavingsGoalNameValidationError? nameValidationError,
    CreateSavingsGoalTargetAmountValidationError? targetAmountValidationError,
    CreateSavingsGoalDescriptionValidationError? descriptionValidationError,
    @Default(false) bool isSubmitting,
    @Default(false) bool isValid,
    String? errorMessage,
    CreateSavingsGoalErrorEvent? errorEvent,
    CreateSavingsGoalSuccessEvent? successEvent,
  }) = _CreateSavingsGoalViewState;
}
