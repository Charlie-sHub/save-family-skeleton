import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goals_failure.freezed.dart';

@freezed
abstract class SavingsGoalsFailure with _$SavingsGoalsFailure {
  const factory SavingsGoalsFailure.network() = SavingsGoalsNetworkFailure;
  const factory SavingsGoalsFailure.conflict(String message) =
      SavingsGoalsConflictFailure;
  const factory SavingsGoalsFailure.unexpected() =
      SavingsGoalsUnexpectedFailure;
}
