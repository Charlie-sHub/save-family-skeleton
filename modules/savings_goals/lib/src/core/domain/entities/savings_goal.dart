import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal.freezed.dart';

@freezed
abstract class SavingsGoal with _$SavingsGoal {
  const factory SavingsGoal({
    required String id,
    required String childId,
    required String name,
    @Default('') String description,
    required double targetAmount,
    @Default(0) double currentAmount,
  }) = _SavingsGoal;
}
