import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/providers/savings_goals_preferences_provider.dart';
import 'package:savings_goals/src/core/providers/savings_goals_repository_provider.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';

final savingsGoalsListViewModelProvider = NotifierProvider.autoDispose
    .family<SavingsGoalsListViewModel, SavingsGoalsListViewState, String>(
      SavingsGoalsListViewModel.new,
    );

class SavingsGoalsListViewModel extends Notifier<SavingsGoalsListViewState> {
  static const _hideCompletedGoalsPreferenceKey =
      'savings_goals_hide_completed_goals';

  SavingsGoalsListViewModel(this.childId);

  final String childId;
  int _fetchRequestId = 0;
  List<SavingsGoal> _goalsCache = const [];

  @override
  SavingsGoalsListViewState build() {
    final hideCompletedGoals =
        ref
            .read(savingsGoalsPreferencesProvider)
            .getBool(_hideCompletedGoalsPreferenceKey) ??
        false;
    Future.microtask(_loadInitial);

    return SavingsGoalsListViewState.initial(
      childId: childId,
      hideCompletedGoals: hideCompletedGoals,
    );
  }

  Future<void> refresh() async =>
      await _fetchGoals(successEvent: SavingsGoalsListSuccessEvent.refreshed);

  Future<void> reload() async => await _fetchGoals();

  Future<void> retry() async => await _fetchGoals();

  Future<void> toggleHideCompletedGoals(bool value) async {
    if (state.hideCompletedGoals == value) {
      return;
    } else {
      state = state.copyWith(
        hideCompletedGoals: value,
        goals: _visibleGoals(goals: _goalsCache, hideCompletedGoals: value),
      );
    }

    unawaited(
      ref
          .read(savingsGoalsPreferencesProvider)
          .setBool(_hideCompletedGoalsPreferenceKey, value),
    );
  }

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
    if (!state.hasGoals) {
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
    final requestId = ++_fetchRequestId;

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

      if (!ref.mounted || requestId != _fetchRequestId) {
        return;
      } else {
        _goalsCache = goals;
        state = state.copyWith(
          isLoading: false,
          hasGoals: goals.isNotEmpty,
          goals: _visibleGoals(
            goals: goals,
            hideCompletedGoals: state.hideCompletedGoals,
          ),
          failure: null,
          errorEvent: null,
          successEvent: successEvent,
        );
      }
    } on SavingsGoalsFailure catch (failure) {
      if (!ref.mounted || requestId != _fetchRequestId) {
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
      if (!ref.mounted || requestId != _fetchRequestId) {
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

  List<SavingsGoal> _visibleGoals({
    required List<SavingsGoal> goals,
    required bool hideCompletedGoals,
  }) {
    if (!hideCompletedGoals) {
      return List<SavingsGoal>.unmodifiable(goals);
    } else {
      return List<SavingsGoal>.unmodifiable(
        goals.where((goal) => !_isCompleted(goal)),
      );
    }
  }

  bool _isCompleted(SavingsGoal goal) =>
      goal.currentAmount >= goal.targetAmount;
}
