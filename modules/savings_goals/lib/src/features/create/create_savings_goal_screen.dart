import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_model.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_view_state.dart';

class CreateSavingsGoalScreen extends ConsumerWidget {
  const CreateSavingsGoalScreen({
    required this.childId,
    super.key,
  });

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = createSavingsGoalViewModelProvider(childId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    ref.listen<CreateSavingsGoalViewState>(provider, (previous, next) {
      if (next.errorEvent != null || next.successEvent != null) {
        viewModel.clearEvents();
      }
    });

    return Scaffold(
      key: ValueKey<String>('create_savings_goal_screen_$childId'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              onChanged: viewModel.updateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: viewModel.updateTargetAmount,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 4,
              onChanged: viewModel.updateDescription,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isSubmitting || !state.isFormValid
                  ? null
                  : viewModel.submit,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}
