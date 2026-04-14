import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/datasource/savings_goals_remote_datasource_impl.dart';

final savingsGoalsRemoteDatasourceProvider =
    Provider<SavingsGoalsRemoteDatasource>(
      (ref) => SavingsGoalsRemoteDatasourceImpl(),
    );
