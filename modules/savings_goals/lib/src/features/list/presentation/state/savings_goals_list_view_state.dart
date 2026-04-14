import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

part 'savings_goals_list_view_state.freezed.dart';

enum SavingsGoalsListErrorEvent { loadFailed }

enum SavingsGoalsListSuccessEvent { refreshed }

@freezed
abstract class SavingsGoalsListViewState with _$SavingsGoalsListViewState {
  const factory SavingsGoalsListViewState({
    required String childId,
    @Default(false) bool isLoading,
    @Default(<SavingsGoal>[]) List<SavingsGoal> goals,
    SavingsGoalsListErrorEvent? errorEvent,
    SavingsGoalsListSuccessEvent? successEvent,
  }) = _SavingsGoalsListViewState;
}
