import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/create_savings_goal_request_model.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';

final class SavingsGoalsRemoteDatasourceImpl
    implements SavingsGoalsRemoteDatasource {
  static const _latency = Duration(milliseconds: 600);
  static const _networkErrorMessage = 'Network error';
  static const _duplicateNameMessage = 'Goal name already exists';

  static final Map<String, List<SavingsGoalModel>> _goalsByChildId =
      _createSeedGoalsByChildId();

  static int _nextGoalId = 7;
  static int _updateProgressAttempts = 0;

  @override
  Future<List<SavingsGoalModel>> fetchGoals(String childId) async {
    await Future<void>.delayed(_latency);

    if (childId == 'child-error') {
      throw Exception(_networkErrorMessage);
    } else {
      final goals = _goalsByChildId[childId] ?? const <SavingsGoalModel>[];

      return List<SavingsGoalModel>.unmodifiable(goals.map(_copyGoal));
    }
  }

  @override
  Future<SavingsGoalModel> createGoal(
    String childId,
    CreateSavingsGoalRequestModel request,
  ) async {
    await Future<void>.delayed(_latency);

    final goals = _goalsByChildId.putIfAbsent(
      childId,
      () => <SavingsGoalModel>[],
    );

    final hasDuplicateName = goals.any((goal) => goal.name == request.name);

    if (hasDuplicateName) {
      throw Exception(_duplicateNameMessage);
    } else {
      final goal = SavingsGoalModel(
        id: _generateGoalId(),
        childId: childId,
        name: request.name,
        description: request.description,
        targetAmount: request.targetAmount,
        currentAmount: 0,
      );

      goals.add(goal);

      return _copyGoal(goal);
    }
  }

  @override
  Future<SavingsGoalModel> updateProgress(String goalId, double amount) async {
    await Future<void>.delayed(_latency);

    _updateProgressAttempts += 1;

    if (_updateProgressAttempts % 5 == 0) {
      throw Exception(_networkErrorMessage);
    } else {
      for (final entry in _goalsByChildId.entries) {
        final goals = entry.value;
        final index = goals.indexWhere((goal) => goal.id == goalId);

        if (index == -1) {
          continue;
        }

        final updatedGoal = goals[index].copyWith(currentAmount: amount);
        goals[index] = updatedGoal;

        return _copyGoal(updatedGoal);
      }

      throw Exception('Goal not found');
    }
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await Future<void>.delayed(_latency);

    for (final goals in _goalsByChildId.values) {
      goals.removeWhere((goal) => goal.id == goalId);
    }
  }

  static Map<String, List<SavingsGoalModel>> _createSeedGoalsByChildId() {
    return {
      'child-1': [
        _seedGoal(
          id: 'goal-1',
          childId: 'child-1',
          name: 'New Bike',
          description: 'Blue mountain bike',
          targetAmount: 120,
          currentAmount: 45,
        ),
        _seedGoal(
          id: 'goal-2',
          childId: 'child-1',
          name: 'Football Boots',
          description: 'Boots for weekend matches',
          targetAmount: 80,
          currentAmount: 20,
        ),
        _seedGoal(
          id: 'goal-3',
          childId: 'child-1',
          name: 'Board Game',
          description: 'Strategy game for family nights',
          targetAmount: 35,
          currentAmount: 10,
        ),
      ],
      'child-2': [
        _seedGoal(
          id: 'goal-4',
          childId: 'child-2',
          name: 'Skateboard',
          description: 'Street skateboard setup',
          targetAmount: 95,
          currentAmount: 30,
        ),
        _seedGoal(
          id: 'goal-5',
          childId: 'child-2',
          name: 'Headphones',
          description: 'Wireless over-ear headphones',
          targetAmount: 70,
          currentAmount: 15,
        ),
        _seedGoal(
          id: 'goal-6',
          childId: 'child-2',
          name: 'Art Supplies',
          description: 'Paints and sketchbook set',
          targetAmount: 50,
          currentAmount: 25,
        ),
      ],
    };
  }

  static SavingsGoalModel _seedGoal({
    required String id,
    required String childId,
    required String name,
    required String description,
    required double targetAmount,
    required double currentAmount,
  }) {
    return SavingsGoalModel(
      id: id,
      childId: childId,
      name: name,
      description: description,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
    );
  }

  static SavingsGoalModel _copyGoal(SavingsGoalModel goal) => goal.copyWith();

  static String _generateGoalId() {
    final id = 'goal-$_nextGoalId';
    _nextGoalId += 1;
    return id;
  }
}
