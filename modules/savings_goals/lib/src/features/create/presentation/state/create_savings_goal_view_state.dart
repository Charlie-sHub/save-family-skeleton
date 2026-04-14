import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_savings_goal_view_state.freezed.dart';

enum CreateSavingsGoalErrorEvent { submitFailed }

enum CreateSavingsGoalSuccessEvent { submitted }

@freezed
abstract class CreateSavingsGoalViewState with _$CreateSavingsGoalViewState {
  const factory CreateSavingsGoalViewState({
    required String childId,
    @Default(false) bool isSubmitting,
    @Default(false) bool isFormValid,
    @Default('') String name,
    @Default('') String targetAmount,
    @Default('') String description,
    CreateSavingsGoalErrorEvent? errorEvent,
    CreateSavingsGoalSuccessEvent? successEvent,
  }) = _CreateSavingsGoalViewState;
}
