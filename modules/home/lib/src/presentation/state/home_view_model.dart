import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home/src/presentation/state/home_view_state.dart';
import 'package:savings_goals/savings_goals.dart';

final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
      HomeViewModel.new,
    );

class HomeViewModel extends Notifier<HomeViewState> {
  @override
  HomeViewState build() {
    Future.microtask(_loadInitial);

    return const HomeViewState();
  }

  Future<void> refresh() async => await _fetchChildSavingsSummaries(
    successEvent: HomeSuccessEvent.refreshed,
  );

  void clearEvents() => state = state.copyWith(successEvent: null);

  Future<void> _loadInitial() async => await _fetchChildSavingsSummaries();

  Future<void> _fetchChildSavingsSummaries({
    HomeSuccessEvent? successEvent,
  }) async {
    state = state.copyWith(
      isLoading: true,
      successEvent: null,
    );

    try {
      final childSavingsSummaries = await Future.wait([
        _buildChildSavingsSummary(childId: 'child-1', childName: 'Lucía'),
        _buildChildSavingsSummary(childId: 'child-2', childName: 'Mateo'),
      ]);

      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isLoading: false,
          childSavingsSummaries: childSavingsSummaries,
          successEvent: successEvent,
        );
      }
    } catch (_) {
      if (!ref.mounted) {
        return;
      } else {
        state = state.copyWith(
          isLoading: false,
          successEvent: null,
        );
      }
    }
  }

  Future<HomeChildSavingsSummary> _buildChildSavingsSummary({
    required String childId,
    required String childName,
  }) async {
    final goals = await ref
        .read(savingsGoalsRepositoryProvider)
        .fetchGoals(childId);

    final totalCurrentAmount = goals.fold<double>(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );
    final totalTargetAmount = goals.fold<double>(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );

    return HomeChildSavingsSummary(
      childId: childId,
      childName: childName,
      goalsCount: goals.length,
      totalCurrentAmount: totalCurrentAmount,
      totalTargetAmount: totalTargetAmount,
    );
  }
}
