import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_model.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';
import 'package:savings_goals/src/features/list/widgets/savings_goals_list_body.dart';

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
        final message = _snackBarMessage(context, next);
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
        title: Text(context.translate(I18n.savingsGoalsListTitle)),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Card(
                elevation: 0,
                color: theme.colorFor(ThemeCode.backgroundSecondary),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.colorFor(ThemeCode.border)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SwitchListTile.adaptive(
                  value: state.hideCompletedGoals,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    context.translate(I18n.savingsGoalsListHideCompletedToggle),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorFor(ThemeCode.textPrimary),
                    ),
                  ),
                  onChanged: viewModel.toggleHideCompletedGoals,
                ),
              ),
            ),
            Expanded(
              child: SavingsGoalsListBody(
                state: state,
                theme: theme,
                onRefresh: viewModel.refresh,
                onRetry: viewModel.retry,
                onCreateGoal: () => _navigateToCreate(
                  context: context,
                  childId: state.childId,
                  viewModel: viewModel,
                ),
                onGoalTap: (goalId) => _navigateToDetail(
                  context: context,
                  childId: state.childId,
                  goalId: goalId,
                  viewModel: viewModel,
                ),
                onDeleteGoal: viewModel.deleteGoal,
                loadErrorDescription: _failureMessage(
                  context: context,
                  failure: state.failure,
                  fallback: context.translate(I18n.savingsGoalsListLoadFailure),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(
          context: context,
          childId: state.childId,
          viewModel: viewModel,
        ),
        backgroundColor: theme.colorFor(ThemeCode.buttonPrimary),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(context.translate(I18n.savingsGoalsListCreateCta)),
      ),
    );
  }

  String? _snackBarMessage(
    BuildContext context,
    SavingsGoalsListViewState state,
  ) {
    switch (state.successEvent) {
      case SavingsGoalsListSuccessEvent.refreshed:
        return context.translate(I18n.savingsGoalsListRefreshedMessage);
      case SavingsGoalsListSuccessEvent.goalDeleted:
        return context.translate(I18n.savingsGoalsListDeletedMessage);
      case null:
        break;
    }

    switch (state.errorEvent) {
      case SavingsGoalsListErrorEvent.deleteFailed:
        return _failureMessage(
          context: context,
          failure: state.failure,
          fallback: context.translate(I18n.savingsGoalsListDeleteFailure),
        );
      case SavingsGoalsListErrorEvent.loadFailed:
        if (state.goals.isNotEmpty) {
          return _failureMessage(
            context: context,
            failure: state.failure,
            fallback: context.translate(I18n.savingsGoalsListRefreshFailure),
          );
        }
      case null:
        break;
    }

    return null;
  }

  String _failureMessage({
    required BuildContext context,
    required SavingsGoalsFailure? failure,
    required String fallback,
  }) {
    if (failure == null) {
      return fallback;
    } else {
      return failure.when(
        duplicateNameConflict: (message) => message,
        networkError: () => context.translate(I18n.networkErrorTryAgain),
        unknownError: () => fallback,
      );
    }
  }

  Future<void> _navigateToCreate({
    required BuildContext context,
    required String childId,
    required SavingsGoalsListViewModel viewModel,
  }) async {
    final shouldReload = await context.push<bool>(
      AppRoutes.createSavingsGoalPath(childId),
    );

    if (context.mounted && shouldReload == true) {
      await viewModel.reload();
    }
  }

  Future<void> _navigateToDetail({
    required BuildContext context,
    required String childId,
    required String goalId,
    required SavingsGoalsListViewModel viewModel,
  }) async {
    await context.push(AppRoutes.savingsGoalDetailPath(childId, goalId));

    if (context.mounted) {
      await viewModel.reload();
    }
  }
}
