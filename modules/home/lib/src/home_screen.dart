import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home/src/presentation/state/home_view_model.dart';
import 'package:home/src/presentation/state/home_view_state.dart';
import 'package:home/src/widgets/home_child_summary_card.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final theme = ref.watch(themePortProvider);

    ref.listen<HomeViewState>(homeViewModelProvider, (previous, next) {
      if (next.successEvent != null) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(context.translate(I18n.homeRefresh)),
            duration: const Duration(seconds: 1),
          ),
        );
        viewModel.clearEvents();
      }
    });

    return Scaffold(
      backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
      appBar: AppBar(
        title: Text(context.translate(I18n.home)),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate(I18n.homeWelcome),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: theme.colorFor(ThemeCode.textPrimary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.translate(I18n.homeSubtitle),
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorFor(ThemeCode.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody(context, state, theme)),
              const SizedBox(height: 16),
              PrimaryButton(
                label: context.translate(I18n.homeRefresh),
                onPressed: state.isLoading ? null : viewModel.refresh,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    HomeViewState state,
    ThemePort theme,
  ) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator());
    } else if (state.childSavingsSummaries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 40,
              color: theme.colorFor(ThemeCode.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              context.translate(I18n.homeSubtitle),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: theme.colorFor(ThemeCode.textSecondary),
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.separated(
        itemCount: state.childSavingsSummaries.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final summary = state.childSavingsSummaries[index];

          return HomeChildSummaryCard(
            childName: summary.childName,
            goalsCount: summary.goalsCount,
            totalCurrentAmount: summary.totalCurrentAmount,
            totalTargetAmount: summary.totalTargetAmount,
            theme: theme,
            onTap: () => _navigateToSavingsGoals(
              context: context,
              childId: summary.childId,
            ),
          );
        },
      );
    }
  }

  Future<void> _navigateToSavingsGoals({
    required BuildContext context,
    required String childId,
  }) async {
    await context.push(AppRoutes.savingsGoalsListPath(childId));

    if (context.mounted) {
      final container = ProviderScope.containerOf(context, listen: false);
      await container.read(homeViewModelProvider.notifier).reload();
    }
  }
}
