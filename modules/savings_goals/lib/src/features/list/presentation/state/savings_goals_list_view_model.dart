import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';

final savingsGoalsListViewModelProvider = NotifierProvider.autoDispose
    .family<SavingsGoalsListViewModel, SavingsGoalsListViewState, String>(
      SavingsGoalsListViewModel.new,
    );

class SavingsGoalsListViewModel extends Notifier<SavingsGoalsListViewState> {
  SavingsGoalsListViewModel(this.childId);

  final String childId;

  @override
  SavingsGoalsListViewState build() {
    return SavingsGoalsListViewState(childId: childId);
  }

  Future<void> refresh() async {
    state = state.copyWith(
      isLoading: true,
      errorEvent: null,
      successEvent: null,
    );

    await Future<void>.delayed(Duration.zero);

    state = state.copyWith(
      isLoading: false,
      successEvent: SavingsGoalsListSuccessEvent.refreshed,
    );
  }

  void clearEvents() =>
      state = state.copyWith(errorEvent: null, successEvent: null);
}
