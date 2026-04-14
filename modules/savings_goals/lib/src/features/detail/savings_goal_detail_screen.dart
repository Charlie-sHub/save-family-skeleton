import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/features/detail/presentation/state/savings_goal_detail_view_model.dart';
import 'package:savings_goals/src/features/detail/presentation/state/savings_goal_detail_view_state.dart';

class SavingsGoalDetailScreen extends ConsumerWidget {
  const SavingsGoalDetailScreen({
    required this.childId,
    required this.goalId,
    super.key,
  });

  final String childId;
  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (childId: childId, goalId: goalId);
    final provider = savingsGoalDetailViewModelProvider(args);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    ref.listen<SavingsGoalDetailViewState>(provider, (previous, next) {
      if (next.errorEvent != null || next.successEvent != null) {
        viewModel.clearEvents();
      }
    });

    return Scaffold(
      key: ValueKey<String>('savings_goal_detail_screen_$goalId'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (state.isLoading)
              const SizedBox(
                height: 240,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (!state.isLoading)
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: viewModel.updateContributionAmount,
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isSubmitting ? null : viewModel.submitContribution,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.savings_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
