import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_view_state.freezed.dart';

enum HomeSuccessEvent { refreshed }

@freezed
abstract class HomeChildSavingsSummary with _$HomeChildSavingsSummary {
  const factory HomeChildSavingsSummary({
    required String childId,
    required String childName,
    required int goalsCount,
    required double totalCurrentAmount,
    required double totalTargetAmount,
  }) = _HomeChildSavingsSummary;
}

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool isLoading,
    @Default(<HomeChildSavingsSummary>[])
    List<HomeChildSavingsSummary> childSavingsSummaries,
    HomeSuccessEvent? successEvent,
  }) = _HomeViewState;
}
