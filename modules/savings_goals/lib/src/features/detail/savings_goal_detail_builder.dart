import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savings_goals/src/features/detail/savings_goal_detail_screen.dart';

class SavingsGoalDetailBuilder {
  const SavingsGoalDetailBuilder();

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final childId = state.pathParameters['childId']!;
    final goalId = state.pathParameters['goalId']!;

    return MaterialPage(
      key: state.pageKey,
      child: SavingsGoalDetailScreen(
        childId: childId,
        goalId: goalId,
      ),
    );
  }
}
