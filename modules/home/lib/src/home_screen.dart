import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home/src/presentation/state/home_view_model.dart';
import 'package:home/src/presentation/state/home_view_state.dart';
import 'package:localizations/localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final theme = ref.watch(themePortProvider);

    ref.listen<HomeViewState>(homeViewModelProvider, (previous, next) {
      if (next.successEvent != null) {
        ScaffoldMessenger.of(context).showSnackBar(
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
              const SizedBox(height: 32),
              if (state.isLoading)
                const LoadingIndicator()
              else
                Text(
                  '${state.counter}',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: theme.colorFor(ThemeCode.buttonPrimary),
                  ),
                ),
              const Spacer(),
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
}
