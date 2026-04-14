import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';

final class InMemorySavingsGoalsRemoteDatasource
    implements SavingsGoalsRemoteDatasource {
  @override
  Future<List<SavingsGoalModel>> fetchGoals(String childId) {
    throw UnimplementedError();
  }

  @override
  Future<SavingsGoalModel> createGoal({
    required String childId,
    required String name,
    required double targetAmount,
    String? description,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SavingsGoalModel> updateProgress({
    required String goalId,
    required double amount,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGoal(String goalId) {
    throw UnimplementedError();
  }
}
