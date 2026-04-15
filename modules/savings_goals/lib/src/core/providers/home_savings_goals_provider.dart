import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/providers/savings_goals_repository_provider.dart';

typedef HomeSavingsGoalsReader =
    Future<List<SavingsGoal>> Function(String childId);

final homeSavingsGoalsProvider = Provider<HomeSavingsGoalsReader>(
  (ref) => ref.watch(savingsGoalsRepositoryProvider).fetchGoals,
);
