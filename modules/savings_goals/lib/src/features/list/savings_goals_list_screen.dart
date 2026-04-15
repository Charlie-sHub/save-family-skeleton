import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_model.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';
import 'package:savings_goals/src/features/list/widgets/savings_goals_list_body.dart';

const _screenTitle = 'Savings goals';
const _createGoalLabel = 'New goal';
const _refreshedMessage = 'Savings goals refreshed.';
const _goalDeletedMessage = 'Savings goal deleted.';
const _loadFailureFallback = 'We could not load the savings goals.';
const _refreshFailureFallback = 'We could not refresh the savings goals.';
const _deleteFailureFallback = 'We could not delete the savings goal.';
const _networkFailureMessage = 'Please check your connection and try again.';

class SavingsGoalsListScreen extends ConsumerWidget {
  const SavingsGoalsListScreen({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = savingsGoalsListViewModelProvider(childId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final theme = ref.watch(themePortProvider);

    ref.listen<SavingsGoalsListViewState>(provider, (previous, next) {
      if (next.errorEvent == null && next.successEvent == null) {
        return;
      } else {
        final message = _snackBarMessage(next);
        if (message != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        viewModel.clearEvents();
      }
    });

    return Scaffold(
      key: ValueKey<String>('savings_goals_list_screen_${state.childId}'),
      backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
      appBar: AppBar(
        title: const Text(_screenTitle),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: SavingsGoalsListBody(
          state: state,
          theme: theme,
          onRefresh: viewModel.refresh,
          onRetry: viewModel.retry,
          onCreateGoal: () => _navigateToCreate(context, state.childId),
          onDeleteGoal: viewModel.deleteGoal,
          loadErrorDescription: _failureMessage(
            failure: state.failure,
            fallback: _loadFailureFallback,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context, state.childId),
        backgroundColor: theme.colorFor(ThemeCode.buttonPrimary),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(_createGoalLabel),
      ),
    );
  }

  String? _snackBarMessage(SavingsGoalsListViewState state) {
    switch (state.successEvent) {
      case SavingsGoalsListSuccessEvent.refreshed:
        return _refreshedMessage;
      case SavingsGoalsListSuccessEvent.goalDeleted:
        return _goalDeletedMessage;
      case null:
        break;
    }

    switch (state.errorEvent) {
      case SavingsGoalsListErrorEvent.deleteFailed:
        return _failureMessage(
          failure: state.failure,
          fallback: _deleteFailureFallback,
        );
      case SavingsGoalsListErrorEvent.loadFailed:
        if (state.goals.isNotEmpty) {
          return _failureMessage(
            failure: state.failure,
            fallback: _refreshFailureFallback,
          );
        }
      case null:
        break;
    }

    return null;
  }

  String _failureMessage({
    required SavingsGoalsFailure? failure,
    required String fallback,
  }) {
    if (failure == null) {
      return fallback;
    } else {
      return failure.when(
        duplicateNameConflict: (message) => message,
        networkError: () => _networkFailureMessage,
        unknownError: () => fallback,
      );
    }
  }

  void _navigateToCreate(BuildContext context, String childId) =>
      context.push(AppRoutes.createSavingsGoalPath(childId));
}
