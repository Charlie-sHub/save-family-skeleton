import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_savings_goal_request.freezed.dart';

@freezed
abstract class CreateSavingsGoalRequest with _$CreateSavingsGoalRequest {
  const factory CreateSavingsGoalRequest({
    required String name,
    required double targetAmount,
    String? description,
  }) = _CreateSavingsGoalRequest;
}
