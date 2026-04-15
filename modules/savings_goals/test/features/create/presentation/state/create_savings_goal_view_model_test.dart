import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_model.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_state.dart';

void main() {
  group('CreateSavingsGoalViewModel validation', () {
    const childId = 'child-1';
    const validName = 'New Bike';
    const validTargetAmount = '120.50';
    const zeroTargetAmount = '0';
    const negativeTargetAmount = '-10';
    const maxTargetAmount = '10000';
    const aboveMaxTargetAmount = '10000.01';
    const invalidShortName = 'Go';
    final minLengthName = List.filled(3, 'a').join();
    final maxLengthName = List.filled(40, 'a').join();
    final aboveMaxLengthName = List.filled(41, 'a').join();
    final maxLengthDescription = List.filled(200, 'd').join();
    final aboveMaxLengthDescription = List.filled(201, 'd').join();

    late ProviderContainer container;
    late ProviderSubscription<CreateSavingsGoalViewState> subscription;
    late CreateSavingsGoalViewModel viewModel;

    CreateSavingsGoalViewState readState() =>
        container.read(createSavingsGoalViewModelProvider(childId));

    void fillValidForm({
      String name = validName,
      String targetAmount = validTargetAmount,
      String description = '',
    }) {
      viewModel.updateName(name);
      viewModel.updateTargetAmount(targetAmount);
      viewModel.updateDescription(description);
    }

    setUp(() {
      container = ProviderContainer();
      subscription = container.listen<CreateSavingsGoalViewState>(
        createSavingsGoalViewModelProvider(childId),
        (_, _) {},
        fireImmediately: true,
      );
      viewModel = container.read(
        createSavingsGoalViewModelProvider(childId).notifier,
      );
    });

    tearDown(() {
      subscription.close();
      container.dispose();
    });

    test('initial state is not submittable', () {
      // Act
      final currentState = readState();

      // Assert
      expect(currentState.isValid, isFalse);
    });

    test(
      'valid name and valid target amount with empty description become submittable',
      () {
        // Act
        viewModel.updateName(validName);
        viewModel.updateTargetAmount(validTargetAmount);

        // Assert
        expect(readState().nameValidationError, isNull);
        expect(readState().targetAmountValidationError, isNull);
        expect(readState().descriptionValidationError, isNull);
        expect(readState().isValid, isTrue);
      },
    );

    test('name below minimum length is invalid', () {
      // Arrange
      fillValidForm();

      // Act
      viewModel.updateName(invalidShortName);

      // Assert
      expect(
        readState().nameValidationError,
        CreateSavingsGoalNameValidationError.tooShort,
      );
      expect(readState().isValid, isFalse);
    });

    test('name at minimum length is valid', () {
      // Act
      fillValidForm(name: minLengthName);

      // Assert
      expect(readState().nameValidationError, isNull);
      expect(readState().isValid, isTrue);
    });

    test('name at maximum length is valid', () {
      // Act
      fillValidForm(name: maxLengthName);

      // Assert
      expect(readState().nameValidationError, isNull);
      expect(readState().isValid, isTrue);
    });

    test('name above maximum length is invalid', () {
      // Act
      fillValidForm(name: aboveMaxLengthName);

      // Assert
      expect(
        readState().nameValidationError,
        CreateSavingsGoalNameValidationError.tooLong,
      );
      expect(readState().isValid, isFalse);
    });

    test('target amount at zero is invalid', () {
      // Act
      fillValidForm(targetAmount: zeroTargetAmount);

      // Assert
      expect(
        readState().targetAmountValidationError,
        CreateSavingsGoalTargetAmountValidationError.mustBeGreaterThanZero,
      );
      expect(readState().isValid, isFalse);
    });

    test('negative target amount is invalid', () {
      // Act
      fillValidForm(targetAmount: negativeTargetAmount);

      // Assert
      expect(
        readState().targetAmountValidationError,
        CreateSavingsGoalTargetAmountValidationError.mustBeGreaterThanZero,
      );
      expect(readState().isValid, isFalse);
    });

    test('positive decimal target amount is valid', () {
      // Act
      fillValidForm(targetAmount: validTargetAmount);

      // Assert
      expect(readState().targetAmountValidationError, isNull);
      expect(readState().isValid, isTrue);
    });

    test('target amount at 10000 is valid', () {
      // Act
      fillValidForm(targetAmount: maxTargetAmount);

      // Assert
      expect(readState().targetAmountValidationError, isNull);
      expect(readState().isValid, isTrue);
    });

    test('target amount above 10000 is invalid', () {
      // Act
      fillValidForm(targetAmount: aboveMaxTargetAmount);

      // Assert
      expect(
        readState().targetAmountValidationError,
        CreateSavingsGoalTargetAmountValidationError.tooHigh,
      );
      expect(readState().isValid, isFalse);
    });

    test('empty description is valid', () {
      // Arrange
      fillValidForm(description: aboveMaxLengthDescription);

      // Act
      viewModel.updateDescription('');

      // Assert
      expect(readState().descriptionValidationError, isNull);
      expect(readState().isValid, isTrue);
    });

    test('description at 200 characters is valid', () {
      // Act
      fillValidForm(description: maxLengthDescription);

      // Assert
      expect(readState().descriptionValidationError, isNull);
      expect(readState().isValid, isTrue);
    });

    test('description above 200 characters is invalid', () {
      // Act
      fillValidForm(description: aboveMaxLengthDescription);

      // Assert
      expect(
        readState().descriptionValidationError,
        CreateSavingsGoalDescriptionValidationError.tooLong,
      );
      expect(readState().isValid, isFalse);
    });

    test('a single invalid field keeps submit disabled', () {
      // Arrange
      fillValidForm(description: maxLengthDescription);

      // Act
      viewModel.updateDescription(aboveMaxLengthDescription);

      // Assert
      expect(readState().nameValidationError, isNull);
      expect(readState().targetAmountValidationError, isNull);
      expect(
        readState().descriptionValidationError,
        CreateSavingsGoalDescriptionValidationError.tooLong,
      );
      expect(readState().isValid, isFalse);
    });
  });
}
