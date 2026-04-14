import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/features/detail/presentation/state/savings_goal_detail_view_state.dart';

typedef SavingsGoalDetailViewModelArgs = ({String childId, String goalId});

final savingsGoalDetailViewModelProvider = NotifierProvider.autoDispose
    .family<
      SavingsGoalDetailViewModel,
      SavingsGoalDetailViewState,
      SavingsGoalDetailViewModelArgs
    >(SavingsGoalDetailViewModel.new);

class SavingsGoalDetailViewModel extends Notifier<SavingsGoalDetailViewState> {
  SavingsGoalDetailViewModel(this.arguments);

  final SavingsGoalDetailViewModelArgs arguments;

  @override
  SavingsGoalDetailViewState build() {
    return SavingsGoalDetailViewState(
      childId: arguments.childId,
      goalId: arguments.goalId,
    );
  }

  void updateContributionAmount(String value) =>
      state = state.copyWith(contributionAmount: value);

  Future<void> submitContribution() async {
    state = state.copyWith(
      isSubmitting: true,
      errorEvent: null,
      successEvent: null,
    );

    await Future<void>.delayed(Duration.zero);

    state = state.copyWith(
      isSubmitting: false,
      successEvent: SavingsGoalDetailSuccessEvent.progressUpdated,
    );
  }

  void clearEvents() =>
      state = state.copyWith(errorEvent: null, successEvent: null);
}
