import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/repositories/savings_goals_repository.dart';

final class SavingsGoalsRepositoryImpl implements SavingsGoalsRepository {
  SavingsGoalsRepositoryImpl({
    required SavingsGoalsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final SavingsGoalsRemoteDatasource _remoteDatasource;

  @override
  Future<List<SavingsGoal>> fetchGoals(String childId) async {
    final models = await _remoteDatasource.fetchGoals(childId);

    return models.map(_mapToEntity).toList(growable: false);
  }

  @override
  Future<SavingsGoal> createGoal({
    required String childId,
    required String name,
    required double targetAmount,
    String? description,
  }) async {
    final model = await _remoteDatasource.createGoal(
      childId: childId,
      name: name,
      targetAmount: targetAmount,
      description: description,
    );

    return _mapToEntity(model);
  }

  @override
  Future<SavingsGoal> updateProgress({
    required String goalId,
    required double amount,
  }) async {
    final model = await _remoteDatasource.updateProgress(
      goalId: goalId,
      amount: amount,
    );

    return _mapToEntity(model);
  }

  @override
  Future<void> deleteGoal(String goalId) {
    return _remoteDatasource.deleteGoal(goalId);
  }

  SavingsGoal _mapToEntity(SavingsGoalModel model) {
    return SavingsGoal(
      id: model.id,
      childId: model.childId,
      name: model.name,
      description: model.description,
      targetAmount: model.targetAmount,
      currentAmount: model.currentAmount,
    );
  }
}
