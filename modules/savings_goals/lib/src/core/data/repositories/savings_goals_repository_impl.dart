import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/create_savings_goal_request_model.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';
import 'package:savings_goals/src/core/domain/entities/create_savings_goal_request.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/domain/repositories/savings_goals_repository.dart';

final class SavingsGoalsRepositoryImpl implements SavingsGoalsRepository {
  static const _networkErrorMessage = 'Network error';
  static const _duplicateNameMessage = 'Goal name already exists';

  SavingsGoalsRepositoryImpl({
    required SavingsGoalsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final SavingsGoalsRemoteDatasource _remoteDatasource;

  @override
  Future<List<SavingsGoal>> fetchGoals(String childId) async {
    try {
      final models = await _remoteDatasource.fetchGoals(childId);

      return models.map(_mapToEntity).toList(growable: false);
    } on SavingsGoalsFailure {
      rethrow;
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<SavingsGoal> createGoal(
    String childId,
    CreateSavingsGoalRequest request,
  ) async {
    try {
      final model = await _remoteDatasource.createGoal(
        childId,
        CreateSavingsGoalRequestModel.fromDomain(request),
      );

      return _mapToEntity(model);
    } on SavingsGoalsFailure {
      rethrow;
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<SavingsGoal> updateProgress(String goalId, double amount) async {
    try {
      final model = await _remoteDatasource.updateProgress(goalId, amount);

      return _mapToEntity(model);
    } on SavingsGoalsFailure {
      rethrow;
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    try {
      await _remoteDatasource.deleteGoal(goalId);
    } on SavingsGoalsFailure {
      rethrow;
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  SavingsGoal _mapToEntity(SavingsGoalModel model) => model.toDomain();

  SavingsGoalsFailure _mapFailure(Object error) {
    final message = _extractMessage(error);

    if (message == _duplicateNameMessage) {
      return SavingsGoalsFailure.duplicateNameConflict(message);
    } else if (message == _networkErrorMessage) {
      return const SavingsGoalsFailure.networkError();
    } else {
      return const SavingsGoalsFailure.unknownError();
    }
  }

  String _extractMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    } else {
      return message;
    }
  }
}
