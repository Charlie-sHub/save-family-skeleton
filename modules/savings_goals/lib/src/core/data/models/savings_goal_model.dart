import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal_model.freezed.dart';
part 'savings_goal_model.g.dart';

@freezed
abstract class SavingsGoalModel with _$SavingsGoalModel {
  const factory SavingsGoalModel({
    required String id,
    required String childId,
    required String name,
    @Default('') String description,
    required double targetAmount,
    @Default(0) double currentAmount,
  }) = _SavingsGoalModel;

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalModelFromJson(json);
}
