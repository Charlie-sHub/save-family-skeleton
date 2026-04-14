import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

part 'savings_goal_model.freezed.dart';
part 'savings_goal_model.g.dart';

@freezed
abstract class SavingsGoalModel with _$SavingsGoalModel {
  const SavingsGoalModel._();

  const factory SavingsGoalModel({
    required String id,
    required String childId,
    required String name,
    String? description,
    required double targetAmount,
    required double currentAmount,
  }) = _SavingsGoalModel;

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalModelFromJson(json);

  factory SavingsGoalModel.fromDomain(SavingsGoal goal) {
    return SavingsGoalModel(
      id: goal.id,
      childId: goal.childId,
      name: goal.name,
      description: goal.description,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
    );
  }

  SavingsGoal toDomain() {
    return SavingsGoal(
      id: id,
      childId: childId,
      name: name,
      description: description,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
    );
  }
}
