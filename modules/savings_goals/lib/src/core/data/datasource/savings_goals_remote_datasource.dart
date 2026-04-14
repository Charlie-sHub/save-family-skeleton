import 'package:savings_goals/src/core/data/models/create_savings_goal_request_model.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';

abstract interface class SavingsGoalsRemoteDatasource {
  Future<List<SavingsGoalModel>> fetchGoals(String childId);

  Future<SavingsGoalModel> createGoal(
    String childId,
    CreateSavingsGoalRequestModel request,
  );

  Future<SavingsGoalModel> updateProgress(String goalId, double amount);

  Future<void> deleteGoal(String goalId);
}
