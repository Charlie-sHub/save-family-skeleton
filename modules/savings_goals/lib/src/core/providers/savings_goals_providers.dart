import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/data/datasource/in_memory_savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/repositories/savings_goals_repository_impl.dart';
import 'package:savings_goals/src/core/domain/repositories/savings_goals_repository.dart';

final savingsGoalsRemoteDatasourceProvider = Provider<SavingsGoalsRemoteDatasource>(
  (ref) => InMemorySavingsGoalsRemoteDatasource(),
);

final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>(
  (ref) => SavingsGoalsRepositoryImpl(
    remoteDatasource: ref.watch(savingsGoalsRemoteDatasourceProvider),
  ),
);
