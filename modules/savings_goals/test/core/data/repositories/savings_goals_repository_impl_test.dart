import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/create_savings_goal_request_model.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_model.dart';
import 'package:savings_goals/src/core/data/repositories/savings_goals_repository_impl.dart';
import 'package:savings_goals/src/core/domain/entities/create_savings_goal_request.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';

import 'savings_goals_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SavingsGoalsRemoteDatasource>()])
void main() {
  group('SavingsGoalsRepositoryImpl', () {
    const childId = 'child-1';
    const errorChildId = 'child-error';
    const firstGoalId = 'goal-1';
    const firstGoalName = 'New Bike';
    const firstGoalDescription = 'Blue mountain bike';
    const firstGoalTargetAmount = 120.0;
    const firstGoalCurrentAmount = 45.0;
    const secondGoalId = 'goal-2';
    const secondGoalName = 'Football Boots';
    const secondGoalDescription = 'Boots for weekend matches';
    const secondGoalTargetAmount = 80.0;
    const secondGoalCurrentAmount = 20.0;
    const targetAmount = 120.0;
    const duplicateNameMessage = 'Goal name already exists';
    const networkErrorMessage = 'Network error';

    late MockSavingsGoalsRemoteDatasource remoteDatasource;
    late SavingsGoalsRepositoryImpl repository;

    setUp(() {
      remoteDatasource = MockSavingsGoalsRemoteDatasource();
      repository = SavingsGoalsRepositoryImpl(
        remoteDatasource: remoteDatasource,
      );
    });

    test(
      'fetchGoals returns mapped domain goals when datasource succeeds',
      () async {
        // Arrange
        const goalModels = <SavingsGoalModel>[
          SavingsGoalModel(
            id: firstGoalId,
            childId: childId,
            name: firstGoalName,
            description: firstGoalDescription,
            targetAmount: firstGoalTargetAmount,
            currentAmount: firstGoalCurrentAmount,
          ),
          SavingsGoalModel(
            id: secondGoalId,
            childId: childId,
            name: secondGoalName,
            description: secondGoalDescription,
            targetAmount: secondGoalTargetAmount,
            currentAmount: secondGoalCurrentAmount,
          ),
        ];

        when(
          remoteDatasource.fetchGoals(childId),
        ).thenAnswer((_) async => goalModels);

        // Act
        final result = await repository.fetchGoals(childId);

        // Assert
        expect(result, const <SavingsGoal>[
          SavingsGoal(
            id: firstGoalId,
            childId: childId,
            name: firstGoalName,
            description: firstGoalDescription,
            targetAmount: firstGoalTargetAmount,
            currentAmount: firstGoalCurrentAmount,
          ),
          SavingsGoal(
            id: secondGoalId,
            childId: childId,
            name: secondGoalName,
            description: secondGoalDescription,
            targetAmount: secondGoalTargetAmount,
            currentAmount: secondGoalCurrentAmount,
          ),
        ]);
        verify(remoteDatasource.fetchGoals(childId)).called(1);
      },
    );

    test(
      'createGoal throws duplicateNameConflict when datasource reports duplicate name',
      () async {
        // Arrange
        const request = CreateSavingsGoalRequest(
          name: firstGoalName,
          targetAmount: targetAmount,
          description: firstGoalDescription,
        );

        const requestModel = CreateSavingsGoalRequestModel(
          name: firstGoalName,
          targetAmount: targetAmount,
          description: firstGoalDescription,
        );

        when(
          remoteDatasource.createGoal(childId, requestModel),
        ).thenThrow(Exception(duplicateNameMessage));

        final action = repository.createGoal(childId, request);

        // Act
        final matcher = throwsA(
          isA<SavingsGoalsDuplicateNameConflictFailure>().having(
            (failure) => failure.message,
            'message',
            duplicateNameMessage,
          ),
        );

        // Assert
        await expectLater(action, matcher);
        verify(remoteDatasource.createGoal(childId, requestModel)).called(1);
      },
    );

    test(
      'fetchGoals throws networkError when datasource reports network failure',
      () async {
        // Arrange
        when(
          remoteDatasource.fetchGoals(errorChildId),
        ).thenThrow(Exception(networkErrorMessage));

        final action = repository.fetchGoals(errorChildId);

        // Act
        final matcher = throwsA(isA<SavingsGoalsNetworkErrorFailure>());

        // Assert
        await expectLater(action, matcher);
        verify(remoteDatasource.fetchGoals(errorChildId)).called(1);
      },
    );
  });
}
