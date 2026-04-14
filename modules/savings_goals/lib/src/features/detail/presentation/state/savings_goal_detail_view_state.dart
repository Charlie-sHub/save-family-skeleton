import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal_detail_view_state.freezed.dart';

enum SavingsGoalDetailErrorEvent { updateFailed }

enum SavingsGoalDetailSuccessEvent { progressUpdated }

@freezed
abstract class SavingsGoalDetailViewState with _$SavingsGoalDetailViewState {
  const factory SavingsGoalDetailViewState({
    required String childId,
    required String goalId,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default('') String contributionAmount,
    SavingsGoalDetailErrorEvent? errorEvent,
    SavingsGoalDetailSuccessEvent? successEvent,
  }) = _SavingsGoalDetailViewState;
}
