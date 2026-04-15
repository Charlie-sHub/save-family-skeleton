import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';

part 'savings_goal_detail_view_state.freezed.dart';

enum SavingsGoalDetailErrorEvent { loadFailed, updateFailed }

enum SavingsGoalDetailSuccessEvent { progressUpdated, goalAchieved }

@freezed
abstract class SavingsGoalDetailViewState with _$SavingsGoalDetailViewState {
  factory SavingsGoalDetailViewState.initial({
    required String childId,
    required String goalId,
  }) => SavingsGoalDetailViewState(
    childId: childId,
    goalId: goalId,
    isLoading: true,
  );

  const factory SavingsGoalDetailViewState({
    required String childId,
    required String goalId,
    @Default(false) bool isLoading,
    SavingsGoal? goal,
    @Default(false) bool isSubmitting,
    @Default('') String contributionAmount,
    @Default(false) bool isValid,
    SavingsGoalsFailure? failure,
    SavingsGoalDetailErrorEvent? errorEvent,
    SavingsGoalDetailSuccessEvent? successEvent,
  }) = _SavingsGoalDetailViewState;
}
