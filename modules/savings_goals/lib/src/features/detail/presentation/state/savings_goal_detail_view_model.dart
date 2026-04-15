import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/providers/savings_goals_repository_provider.dart';
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
    Future.microtask(_loadGoal);

    return SavingsGoalDetailViewState.initial(
      childId: arguments.childId,
      goalId: arguments.goalId,
    );
  }

  void updateContributionAmount(String value) {
    final validation = _validateContributionAmount(
      contributionAmount: value,
      goal: state.goal,
      isLoading: state.isLoading,
      isSubmitting: state.isSubmitting,
    );

    state = state.copyWith(
      contributionAmount: value,
      isValid: validation.isValid,
    );
  }

  Future<void> submitContribution() async {
    final goal = state.goal;
    final validation = _validateContributionAmount(
      contributionAmount: state.contributionAmount,
      goal: goal,
      isLoading: state.isLoading,
      isSubmitting: false,
    );

    state = state.copyWith(
      isValid: validation.isValid,
      errorEvent: null,
      successEvent: null,
    );

    if (!validation.isValid ||
        validation.parsedContributionAmount == null ||
        goal == null) {
      return;
    } else {
      state = state.copyWith(isSubmitting: true, isValid: false, failure: null);
    }

    final newTotal = goal.currentAmount + validation.parsedContributionAmount!;

    try {
      final updatedGoal = await ref
          .read(savingsGoalsRepositoryProvider)
          .updateProgress(goal.id, newTotal);

      if (!ref.mounted) {
        return;
      } else {
        final successEvent = !_isCompleted(goal) && _isCompleted(updatedGoal)
            ? SavingsGoalDetailSuccessEvent.goalAchieved
            : SavingsGoalDetailSuccessEvent.progressUpdated;

        state = state.copyWith(
          goal: updatedGoal,
          isSubmitting: false,
          contributionAmount: '',
          isValid: false,
          failure: null,
          errorEvent: null,
          successEvent: successEvent,
        );
      }
    } on SavingsGoalsFailure catch (failure) {
      if (!ref.mounted) {
        return;
      } else {
        _handleUpdateFailure(goal: goal, failure: failure);
      }
    } catch (_) {
      if (!ref.mounted) {
        return;
      } else {
        _handleUpdateFailure(
          goal: goal,
          failure: const SavingsGoalsFailure.unknownError(),
        );
      }
    }
  }

  void clearEvents() {
    if (state.goal == null) {
      state = state.copyWith(errorEvent: null, successEvent: null);
    } else {
      state = state.copyWith(
        failure: null,
        errorEvent: null,
        successEvent: null,
      );
    }
  }

  Future<void> _loadGoal() async {
    state = state.copyWith(
      isLoading: true,
      isValid: false,
      failure: null,
      errorEvent: null,
      successEvent: null,
    );

    try {
      final goals = await ref
          .read(savingsGoalsRepositoryProvider)
          .fetchGoals(arguments.childId);
      SavingsGoal? selectedGoal;

      for (final goal in goals) {
        if (goal.id == arguments.goalId) {
          selectedGoal = goal;
          break;
        }
      }

      if (!ref.mounted) {
        return;
      } else if (selectedGoal == null) {
        _handleLoadFailure(const SavingsGoalsFailure.unknownError());
      } else {
        final validation = _validateContributionAmount(
          contributionAmount: state.contributionAmount,
          goal: selectedGoal,
          isLoading: false,
          isSubmitting: false,
        );

        state = state.copyWith(
          isLoading: false,
          goal: selectedGoal,
          isValid: validation.isValid,
          failure: null,
          errorEvent: null,
          successEvent: null,
        );
      }
    } on SavingsGoalsFailure catch (failure) {
      if (!ref.mounted) {
        return;
      } else {
        _handleLoadFailure(failure);
      }
    } catch (_) {
      if (!ref.mounted) {
        return;
      } else {
        _handleLoadFailure(const SavingsGoalsFailure.unknownError());
      }
    }
  }

  ({double? parsedContributionAmount, bool isValid})
  _validateContributionAmount({
    required String contributionAmount,
    required SavingsGoal? goal,
    required bool isLoading,
    required bool isSubmitting,
  }) {
    final trimmedContributionAmount = contributionAmount.trim();
    final parsedContributionAmount = double.tryParse(trimmedContributionAmount);
    final isValid =
        goal != null &&
        !isLoading &&
        !isSubmitting &&
        trimmedContributionAmount.isNotEmpty &&
        parsedContributionAmount != null &&
        parsedContributionAmount > 0;

    return (
      parsedContributionAmount: parsedContributionAmount,
      isValid: isValid,
    );
  }

  void _handleUpdateFailure({
    required SavingsGoal? goal,
    required SavingsGoalsFailure failure,
  }) {
    final validation = _validateContributionAmount(
      contributionAmount: state.contributionAmount,
      goal: goal,
      isLoading: false,
      isSubmitting: false,
    );

    state = state.copyWith(
      isSubmitting: false,
      isValid: validation.isValid,
      failure: failure,
      errorEvent: SavingsGoalDetailErrorEvent.updateFailed,
      successEvent: null,
    );
  }

  void _handleLoadFailure(SavingsGoalsFailure failure) =>
      state = state.copyWith(
        isLoading: false,
        goal: null,
        isValid: false,
        failure: failure,
        errorEvent: SavingsGoalDetailErrorEvent.loadFailed,
        successEvent: null,
      );

  bool _isCompleted(SavingsGoal goal) =>
      goal.currentAmount >= goal.targetAmount;
}
