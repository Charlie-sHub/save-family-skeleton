import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:home/home.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/savings_goals.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
late final GoRouter appRouter;

void configureAppRouter() {
  appRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _RootShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                pageBuilder: const HomeBuilder().buildPage,
              ),
              GoRoute(
                path: AppRoutes.savingsGoalsList,
                name: 'savingsGoalsList',
                pageBuilder: const SavingsGoalsListBuilder().buildPage,
              ),
              GoRoute(
                path: AppRoutes.createSavingsGoal,
                name: 'createSavingsGoal',
                pageBuilder: const CreateSavingsGoalBuilder().buildPage,
              ),
              GoRoute(
                path: AppRoutes.savingsGoalDetail,
                name: 'savingsGoalDetail',
                pageBuilder: const SavingsGoalDetailBuilder().buildPage,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.activity,
                name: 'activity',
                pageBuilder: const ActivityBuilder().buildPage,
              ),
            ],
          ),
        ],
      ),
    ],
  );

  GetIt.I<NavigationContract>().setRouter(appRouter);
}

class _RootShell extends StatelessWidget {
  const _RootShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.translate(I18n.home),
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: context.translate(I18n.activity),
          ),
        ],
      ),
    );
  }
}
