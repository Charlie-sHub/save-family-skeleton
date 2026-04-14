import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home/src/home_screen.dart';

class HomeBuilder {
  const HomeBuilder();

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: state.pageKey,
      child: const HomeScreen(),
    );
  }
}
