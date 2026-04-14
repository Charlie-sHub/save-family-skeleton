import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_model.dart';
import 'package:savings_goals/src/features/list/presentation/state/savings_goals_list_view_state.dart';

class SavingsGoalsListScreen extends ConsumerWidget {
  const SavingsGoalsListScreen({
    required this.childId,
    super.key,
  });

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = savingsGoalsListViewModelProvider(childId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    ref.listen<SavingsGoalsListViewState>(provider, (previous, next) {
      if (next.errorEvent != null || next.successEvent != null) {
        viewModel.clearEvents();
      }
    });

    return Scaffold(
      key: ValueKey<String>('savings_goals_list_screen_$childId'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: viewModel.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              if (state.isLoading)
                const SizedBox(
                  height: 320,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (!state.isLoading)
                for (final goal in state.goals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      child: SizedBox(
                        height: 72,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: LinearProgressIndicator(
                            value: goal.targetAmount == 0
                                ? 0
                                : (goal.currentAmount / goal.targetAmount)
                                    .clamp(0, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
