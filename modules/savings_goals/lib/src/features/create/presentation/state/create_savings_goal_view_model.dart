import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_state.dart';

final createSavingsGoalViewModelProvider = NotifierProvider.autoDispose.family<
    CreateSavingsGoalViewModel, CreateSavingsGoalViewState, String>(
  CreateSavingsGoalViewModel.new,
);

class CreateSavingsGoalViewModel extends Notifier<CreateSavingsGoalViewState> {
  CreateSavingsGoalViewModel(this.childId);

  final String childId;

  @override
  CreateSavingsGoalViewState build() {
    return CreateSavingsGoalViewState(childId: childId);
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateTargetAmount(String value) {
    state = state.copyWith(targetAmount: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  Future<void> submit() async {
    state = state.copyWith(
      isSubmitting: true,
      errorEvent: null,
      successEvent: null,
    );

    await Future<void>.delayed(Duration.zero);

    state = state.copyWith(
      isSubmitting: false,
      successEvent: CreateSavingsGoalSuccessEvent.submitted,
    );
  }

  void clearEvents() {
    state = state.copyWith(
      errorEvent: null,
      successEvent: null,
    );
  }
}
