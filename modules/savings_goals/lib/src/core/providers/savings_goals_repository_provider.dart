import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/data/repositories/savings_goals_repository_impl.dart';
import 'package:savings_goals/src/core/domain/repositories/savings_goals_repository.dart';
import 'package:savings_goals/src/core/providers/savings_goals_datasource_provider.dart';

final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>(
  (ref) => SavingsGoalsRepositoryImpl(
    remoteDatasource: ref.watch(savingsGoalsRemoteDatasourceProvider),
  ),
);
