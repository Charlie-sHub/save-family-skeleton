import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

part 'savings_goals_list_view_state.freezed.dart';

enum SavingsGoalsListErrorEvent { loadFailed, deleteFailed }

enum SavingsGoalsListSuccessEvent { refreshed, goalDeleted }

@freezed
abstract class SavingsGoalsListViewState with _$SavingsGoalsListViewState {
  factory SavingsGoalsListViewState.initial({
    required String childId,
    bool hideCompletedGoals = false,
  }) => SavingsGoalsListViewState(
    childId: childId,
    hideCompletedGoals: hideCompletedGoals,
  );

  const factory SavingsGoalsListViewState({
    required String childId,
    @Default(false) bool isLoading,
    @Default(false) bool hasGoals,
    @Default(false) bool hideCompletedGoals,
    @Default(<SavingsGoal>[]) List<SavingsGoal> goals,
    SavingsGoalsFailure? failure,
    SavingsGoalsListErrorEvent? errorEvent,
    SavingsGoalsListSuccessEvent? successEvent,
  }) = _SavingsGoalsListViewState;
}
