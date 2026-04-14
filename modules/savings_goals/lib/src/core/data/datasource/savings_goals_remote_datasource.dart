import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';

abstract interface class SavingsGoalsRemoteDatasource {
  Future<List<SavingsGoalModel>> fetchGoals(String childId);

  Future<SavingsGoalModel> createGoal({
    required String childId,
    required String name,
    required double targetAmount,
    String? description,
  });

  Future<SavingsGoalModel> updateProgress({
    required String goalId,
    required double amount,
  });

  Future<void> deleteGoal(String goalId);
}
