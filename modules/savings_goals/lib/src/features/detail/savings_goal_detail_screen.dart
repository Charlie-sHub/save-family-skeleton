import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/features/detail/presentation/state/savings_goal_detail_view_model.dart';
import 'package:savings_goals/src/features/detail/presentation/state/savings_goal_detail_view_state.dart';
import 'package:savings_goals/src/features/detail/widgets/savings_goal_detail_content.dart';
import 'package:savings_goals/src/features/detail/widgets/savings_goal_detail_error_view.dart';

const _screenTitle = 'Savings goal';
const _progressUpdatedMessage = 'Savings goal updated.';
const _loadFailureFallback = 'We could not load the savings goal.';
const _updateFailureFallback = 'We could not update the savings goal.';
const _networkFailureMessage = 'Please check your connection and try again.';
const _goalAchievedTitle = 'Goal achieved';
const _goalAchievedDescription =
    'This savings goal has reached its target amount.';

class SavingsGoalDetailScreen extends ConsumerStatefulWidget {
  const SavingsGoalDetailScreen({
    required this.childId,
    required this.goalId,
    super.key,
  });

  final String childId;
  final String goalId;

  @override
  ConsumerState<SavingsGoalDetailScreen> createState() =>
      _SavingsGoalDetailScreenState();
}

class _SavingsGoalDetailScreenState
    extends ConsumerState<SavingsGoalDetailScreen> {
  late final TextEditingController _contributionController;

  @override
  void initState() {
    super.initState();
    _contributionController = TextEditingController();
  }

  @override
  void dispose() {
    _contributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = (childId: widget.childId, goalId: widget.goalId);
    final provider = savingsGoalDetailViewModelProvider(args);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final theme = ref.watch(themePortProvider);

    if (_contributionController.text != state.contributionAmount) {
      _contributionController.value = TextEditingValue(
        text: state.contributionAmount,
        selection: TextSelection.collapsed(
          offset: state.contributionAmount.length,
        ),
      );
    }

    ref.listen<SavingsGoalDetailViewState>(provider, (previous, next) {
      _handleSideEffects(context: context, viewModel: viewModel, state: next);
    });

    return Scaffold(
      key: ValueKey<String>('savings_goal_detail_screen_${widget.goalId}'),
      backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
      appBar: AppBar(
        title: const Text(_screenTitle),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildBody(theme: theme, state: state, viewModel: viewModel),
      ),
    );
  }

  Widget _buildBody({
    required ThemePort theme,
    required SavingsGoalDetailViewState state,
    required SavingsGoalDetailViewModel viewModel,
  }) {
    if (state.isLoading && state.goal == null) {
      return const Center(child: LoadingIndicator());
    } else if (state.goal == null) {
      return SavingsGoalDetailErrorView(
        theme: theme,
        description: _failureMessage(
          failure: state.failure,
          fallback: _loadFailureFallback,
        ),
      );
    } else {
      return SavingsGoalDetailContent(
        theme: theme,
        goal: state.goal!,
        contributionController: _contributionController,
        isSubmitting: state.isSubmitting,
        isSubmitEnabled: state.isValid,
        onContributionChanged: viewModel.updateContributionAmount,
        onSubmit: viewModel.submitContribution,
      );
    }
  }

  Future<void> _handleSideEffects({
    required BuildContext context,
    required SavingsGoalDetailViewModel viewModel,
    required SavingsGoalDetailViewState state,
  }) async {
    if (state.errorEvent == null && state.successEvent == null) {
      return;
    } else {
      final messenger = ScaffoldMessenger.of(context);

      switch (state.successEvent) {
        case SavingsGoalDetailSuccessEvent.progressUpdated:
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            const SnackBar(
              content: Text(_progressUpdatedMessage),
              duration: Duration(seconds: 2),
            ),
          );
          viewModel.clearEvents();
          return;
        case SavingsGoalDetailSuccessEvent.goalAchieved:
          viewModel.clearEvents();
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(_goalAchievedTitle),
              content: const Text(_goalAchievedDescription),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        case null:
          break;
      }

      switch (state.errorEvent) {
        case SavingsGoalDetailErrorEvent.updateFailed:
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                _failureMessage(
                  failure: state.failure,
                  fallback: _updateFailureFallback,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          viewModel.clearEvents();
          return;
        case SavingsGoalDetailErrorEvent.loadFailed:
        case null:
          viewModel.clearEvents();
          return;
      }
    }
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
}
