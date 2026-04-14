import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savings_goals/src/features/list/savings_goals_list_screen.dart';

class SavingsGoalsListBuilder {
  const SavingsGoalsListBuilder();

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final childId = state.pathParameters['childId']!;

    return MaterialPage(
      key: state.pageKey,
      child: SavingsGoalsListScreen(childId: childId),
    );
  }
}
