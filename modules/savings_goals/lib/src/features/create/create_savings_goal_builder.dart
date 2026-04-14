import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savings_goals/src/features/create/create_savings_goal_screen.dart';

class CreateSavingsGoalBuilder {
  const CreateSavingsGoalBuilder();

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final childId = state.pathParameters['childId']!;

    return MaterialPage(
      key: state.pageKey,
      child: CreateSavingsGoalScreen(childId: childId),
    );
  }
}
