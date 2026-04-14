import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/create_savings_goal_request.dart';

part 'create_savings_goal_request_model.freezed.dart';
part 'create_savings_goal_request_model.g.dart';

@freezed
abstract class CreateSavingsGoalRequestModel
    with _$CreateSavingsGoalRequestModel {
  const factory CreateSavingsGoalRequestModel({
    required String name,
    required double targetAmount,
    String? description,
  }) = _CreateSavingsGoalRequestModel;

  factory CreateSavingsGoalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSavingsGoalRequestModelFromJson(json);

  factory CreateSavingsGoalRequestModel.fromDomain(
    CreateSavingsGoalRequest request,
  ) {
    return CreateSavingsGoalRequestModel(
      name: request.name,
      targetAmount: request.targetAmount,
      description: request.description,
    );
  }
}
