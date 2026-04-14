import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal.freezed.dart';

@freezed
abstract class SavingsGoal with _$SavingsGoal {
  const SavingsGoal._();

  const factory SavingsGoal({
    required String id,
    required String childId,
    required String name,
    String? description,
    required double targetAmount,
    @Default(0) double currentAmount,
  }) = _SavingsGoal;

  double get progressRatio {
    if (targetAmount <= 0) {
      return 0;
    } else {
      return (currentAmount / targetAmount).clamp(0, 1).toDouble();
    }
  }
}
