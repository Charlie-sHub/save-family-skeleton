import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';
import 'package:savings_goals/src/features/list/widgets/savings_goal_card.dart';
import 'package:savings_goals/src/features/list/widgets/savings_goals_list_message_view.dart';

const _statusStateHeight = 320.0;

class SavingsGoalsListBody extends StatelessWidget {
  const SavingsGoalsListBody({
    required this.state,
    required this.theme,
    required this.onRefresh,
    required this.onRetry,
    required this.onCreateGoal,
    required this.onGoalTap,
    required this.onDeleteGoal,
    required this.loadErrorDescription,
    super.key,
  });

  final SavingsGoalsListViewState state;
  final ThemePort theme;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onRetry;
  final VoidCallback onCreateGoal;
  final void Function(String goalId) onGoalTap;
  final Future<void> Function(String goalId) onDeleteGoal;
  final String loadErrorDescription;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.goals.isEmpty) {
      return _buildStatusState(
        child: const SizedBox(
          height: _statusStateHeight,
          child: LoadingIndicator(),
        ),
      );
    } else if (state.failure != null && state.goals.isEmpty) {
      return _buildStatusState(
        child: SavingsGoalsListMessageView(
          theme: theme,
          title: context.translate(I18n.error),
          description: loadErrorDescription,
          actionLabel: context.translate(I18n.retry),
          onPressed: onRetry,
        ),
      );
    } else if (state.goals.isEmpty) {
      return _buildStatusState(
        child: SavingsGoalsListMessageView(
          theme: theme,
          title: context.translate(I18n.savingsGoalsListEmptyTitle),
          description: context.translate(I18n.savingsGoalsListEmptyDescription),
          actionLabel: context.translate(I18n.savingsGoalsListCreateCta),
          onPressed: onCreateGoal,
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          itemCount: state.goals.length + (state.isLoading ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (state.isLoading && index == 0) {
              return LinearProgressIndicator(
                minHeight: 4,
                color: theme.colorFor(ThemeCode.buttonPrimary),
                backgroundColor: theme.colorFor(ThemeCode.border),
              );
            } else {
              final goalIndex = state.isLoading ? index - 1 : index;
              final goal = state.goals[goalIndex];

              return SavingsGoalCard(
                goal: goal,
                theme: theme,
                onTap: state.isLoading ? null : () => onGoalTap(goal.id),
                onDelete: state.isLoading ? null : () => onDeleteGoal(goal.id),
              );
            }
          },
        ),
      );
    }
  }

  Widget _buildStatusState({required Widget child}) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [child],
    ),
  );
}
