import 'package:savings_goals/src/core/domain/entities/create_savings_goal_request.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

abstract interface class SavingsGoalsRepository {
  Future<List<SavingsGoal>> fetchGoals(String childId);

  Future<SavingsGoal> createGoal(
    String childId,
    CreateSavingsGoalRequest request,
  );

  Future<SavingsGoal> updateProgress(String goalId, double amount);

  Future<void> deleteGoal(String goalId);
}
