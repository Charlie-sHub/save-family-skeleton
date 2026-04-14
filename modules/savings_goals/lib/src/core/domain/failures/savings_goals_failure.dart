import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goals_failure.freezed.dart';

@freezed
abstract class SavingsGoalsFailure with _$SavingsGoalsFailure {
  const factory SavingsGoalsFailure.duplicateNameConflict(String message) =
      SavingsGoalsDuplicateNameConflictFailure;
  const factory SavingsGoalsFailure.networkError() =
      SavingsGoalsNetworkErrorFailure;
  const factory SavingsGoalsFailure.unknownError() =
      SavingsGoalsUnknownErrorFailure;
}
