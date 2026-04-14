import 'package:activity/src/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActivityBuilder {
  const ActivityBuilder();

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: state.pageKey,
      child: const ActivityScreen(),
    );
  }
}
