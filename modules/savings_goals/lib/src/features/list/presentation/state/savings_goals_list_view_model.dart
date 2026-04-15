import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/providers/savings_goals_repository_provider.dart';
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
    Future.microtask(_loadInitial);

    return SavingsGoalsListViewState.initial(childId: childId);
  }

  Future<void> refresh() async =>
      await _fetchGoals(successEvent: SavingsGoalsListSuccessEvent.refreshed);

  Future<void> reload() async => await _fetchGoals();

  Future<void> retry() async => await _fetchGoals();

  Future<void> deleteGoal(String goalId) async {
    state = state.copyWith(failure: null, errorEvent: null, successEvent: null);

    try {
      await ref.read(savingsGoalsRepositoryProvider).deleteGoal(goalId);

      if (!ref.mounted) {
        return;
      } else {
        await _fetchGoals(
          successEvent: SavingsGoalsListSuccessEvent.goalDeleted,
        );
      }
    } on SavingsGoalsFailure catch (failure) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          failure: failure,
          errorEvent: SavingsGoalsListErrorEvent.deleteFailed,
          successEvent: null,
        );
      }
    } catch (_) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          failure: const SavingsGoalsFailure.unknownError(),
          errorEvent: SavingsGoalsListErrorEvent.deleteFailed,
          successEvent: null,
        );
      }
    }
  }

  void clearEvents() {
    if (state.goals.isEmpty) {
      state = state.copyWith(errorEvent: null, successEvent: null);
    } else {
      state = state.copyWith(
        failure: null,
        errorEvent: null,
        successEvent: null,
      );
    }
  }

  Future<void> _loadInitial() async {
    await _fetchGoals();
  }

  Future<void> _fetchGoals({SavingsGoalsListSuccessEvent? successEvent}) async {
    state = state.copyWith(
      isLoading: true,
      failure: null,
      errorEvent: null,
      successEvent: null,
    );

    try {
      final goals = await ref
          .read(savingsGoalsRepositoryProvider)
          .fetchGoals(childId);

      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isLoading: false,
          goals: goals,
          failure: null,
          errorEvent: null,
          successEvent: successEvent,
        );
      }
    } on SavingsGoalsFailure catch (failure) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isLoading: false,
          failure: failure,
          errorEvent: SavingsGoalsListErrorEvent.loadFailed,
          successEvent: null,
        );
      }
    } catch (_) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isLoading: false,
          failure: const SavingsGoalsFailure.unknownError(),
          errorEvent: SavingsGoalsListErrorEvent.loadFailed,
          successEvent: null,
        );
      }
    }
  }
}
