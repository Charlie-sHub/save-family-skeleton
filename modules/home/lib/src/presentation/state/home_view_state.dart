import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_view_state.freezed.dart';

enum HomeErrorEvent { loadFailed }

enum HomeSuccessEvent { refreshed }

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default(false) bool isLoading,
    @Default(0) int counter,
    HomeErrorEvent? errorEvent,
    HomeSuccessEvent? successEvent,
  }) = _HomeViewState;
}
