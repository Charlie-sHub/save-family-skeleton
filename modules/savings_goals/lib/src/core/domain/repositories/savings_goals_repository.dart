import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

abstract interface class SavingsGoalsRepository {
  Future<List<SavingsGoal>> fetchGoals(String childId);

  Future<SavingsGoal> createGoal({
    required String childId,
    required String name,
    required double targetAmount,
    String? description,
  });

  Future<SavingsGoal> updateProgress({
    required String goalId,
    required double amount,
  });

  Future<void> deleteGoal(String goalId);
}
