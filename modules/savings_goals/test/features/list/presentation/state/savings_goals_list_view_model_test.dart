import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/failures/savings_goals_failure.dart';
import 'package:savings_goals/src/core/providers/savings_goals_preferences_provider.dart';
import 'package:savings_goals/src/core/domain/repositories/savings_goals_repository.dart';
import 'package:savings_goals/src/core/providers/savings_goals_repository_provider.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_model.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';

import 'savings_goals_list_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SavingsGoalsRepository>()])
void main() {
  group('SavingsGoalsListViewModel', () {
    const childId = 'child-1';
    const firstGoal = SavingsGoal(
      id: 'goal-1',
      childId: childId,
      name: 'New Bike',
      description: 'Blue mountain bike',
      targetAmount: 120,
      currentAmount: 45,
    );
    const secondGoal = SavingsGoal(
      id: 'goal-2',
      childId: childId,
      name: 'Football Boots',
      description: 'Boots for weekend matches',
      targetAmount: 80,
      currentAmount: 20,
    );
    const initialGoals = <SavingsGoal>[firstGoal];
    const refreshedGoals = <SavingsGoal>[firstGoal, secondGoal];
    const unknownFailure = SavingsGoalsFailure.unknownError();

    late MockSavingsGoalsRepository repository;
    late SharedPreferences sharedPreferences;
    late ProviderContainer container;

    setUp(() async {
      repository = MockSavingsGoalsRepository();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          savingsGoalsRepositoryProvider.overrideWithValue(repository),
          savingsGoalsPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('emits loading then success when initial load succeeds', () async {
      // Arrange
      final completer = Completer<List<SavingsGoal>>();
      final states = <SavingsGoalsListViewState>[];

      when(repository.fetchGoals(childId)).thenAnswer((_) => completer.future);

      final subscription = container.listen<SavingsGoalsListViewState>(
        savingsGoalsListViewModelProvider(childId),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await Future<void>.delayed(Duration.zero);

      // Act
      completer.complete(initialGoals);
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(states.first, SavingsGoalsListViewState.initial(childId: childId));
      expect(states[1].isLoading, isTrue);
      expect(states[1].goals, isEmpty);
      expect(states.last.isLoading, isFalse);
      expect(states.last.goals, initialGoals);
      expect(states.last.failure, isNull);
      expect(states.last.errorEvent, isNull);
      expect(states.last.successEvent, isNull);
      verify(repository.fetchGoals(childId)).called(1);
      subscription.close();
    });

    test('emits loading then error when initial load fails', () async {
      // Arrange
      final states = <SavingsGoalsListViewState>[];

      when(repository.fetchGoals(childId)).thenThrow(unknownFailure);

      final subscription = container.listen<SavingsGoalsListViewState>(
        savingsGoalsListViewModelProvider(childId),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // Act
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(states.first, SavingsGoalsListViewState.initial(childId: childId));
      expect(states[1].isLoading, isTrue);
      expect(states.last.isLoading, isFalse);
      expect(states.last.goals, isEmpty);
      expect(states.last.failure, unknownFailure);
      expect(states.last.errorEvent, SavingsGoalsListErrorEvent.loadFailed);
      expect(states.last.successEvent, isNull);
      verify(repository.fetchGoals(childId)).called(1);
      subscription.close();
    });

    test('refresh reloads goals and emits refreshed success event', () async {
      // Arrange
      final states = <SavingsGoalsListViewState>[];
      var fetchGoalsCallCount = 0;

      when(repository.fetchGoals(childId)).thenAnswer((_) async {
        fetchGoalsCallCount += 1;

        if (fetchGoalsCallCount == 1) {
          return initialGoals;
        } else {
          return refreshedGoals;
        }
      });

      final subscription = container.listen<SavingsGoalsListViewState>(
        savingsGoalsListViewModelProvider(childId),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final notifier = container.read(
        savingsGoalsListViewModelProvider(childId).notifier,
      );

      // Act
      await notifier.refresh();

      // Assert
      expect(states.first, SavingsGoalsListViewState.initial(childId: childId));
      expect(states[2].goals, initialGoals);
      expect(states.last.isLoading, isFalse);
      expect(states.last.goals, refreshedGoals);
      expect(states.last.failure, isNull);
      expect(states.last.errorEvent, isNull);
      expect(states.last.successEvent, SavingsGoalsListSuccessEvent.refreshed);
      verify(repository.fetchGoals(childId)).called(2);
      subscription.close();
    });

    test('honors the persisted filter on provider rebuild', () async {
      // Arrange
      const completedGoal = SavingsGoal(
        id: 'goal-3',
        childId: childId,
        name: 'Game Console',
        description: 'Portable console',
        targetAmount: 100,
        currentAmount: 100,
      );
      const mixedGoals = <SavingsGoal>[firstGoal, completedGoal];
      final firstContainerStates = <SavingsGoalsListViewState>[];
      final secondContainerStates = <SavingsGoalsListViewState>[];

      SharedPreferences.setMockInitialValues({
        'savings_goals_hide_completed_goals': true,
      });
      sharedPreferences = await SharedPreferences.getInstance();

      container.dispose();
      container = ProviderContainer(
        overrides: [
          savingsGoalsRepositoryProvider.overrideWithValue(repository),
          savingsGoalsPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );

      when(repository.fetchGoals(childId)).thenAnswer((_) async => mixedGoals);

      final firstSubscription = container.listen<SavingsGoalsListViewState>(
        savingsGoalsListViewModelProvider(childId),
        (_, next) => firstContainerStates.add(next),
        fireImmediately: true,
      );

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final rebuiltContainer = ProviderContainer(
        overrides: [
          savingsGoalsRepositoryProvider.overrideWithValue(repository),
          savingsGoalsPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );

      final secondSubscription = rebuiltContainer
          .listen<SavingsGoalsListViewState>(
            savingsGoalsListViewModelProvider(childId),
            (_, next) => secondContainerStates.add(next),
            fireImmediately: true,
          );

      // Act
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(firstContainerStates.first.hideCompletedGoals, isTrue);
      expect(firstContainerStates.last.hideCompletedGoals, isTrue);
      expect(firstContainerStates.last.hasGoals, isTrue);
      expect(firstContainerStates.last.goals, <SavingsGoal>[firstGoal]);

      expect(secondContainerStates.first.hideCompletedGoals, isTrue);
      expect(secondContainerStates.last.hideCompletedGoals, isTrue);
      expect(secondContainerStates.last.hasGoals, isTrue);
      expect(secondContainerStates.last.goals, <SavingsGoal>[firstGoal]);
      verify(repository.fetchGoals(childId)).called(2);

      firstSubscription.close();
      secondSubscription.close();
      rebuiltContainer.dispose();
    });
  });
}
