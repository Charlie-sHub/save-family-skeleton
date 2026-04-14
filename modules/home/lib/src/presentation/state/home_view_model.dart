import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home/src/presentation/state/home_view_state.dart';

final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
      HomeViewModel.new,
    );

class HomeViewModel extends Notifier<HomeViewState> {
  @override
  HomeViewState build() {
    return const HomeViewState();
  }

  Future<void> refresh() async {
    state = state.copyWith(
      isLoading: true,
      errorEvent: null,
      successEvent: null,
    );
    await Future<void>.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(
      isLoading: false,
      counter: state.counter + 1,
      successEvent: HomeSuccessEvent.refreshed,
    );
  }

  void clearEvents() {
    state = state.copyWith(errorEvent: null, successEvent: null);
  }
}
