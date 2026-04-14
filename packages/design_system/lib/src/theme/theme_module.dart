import 'package:design_system/src/theme/theme_adapter.dart';
import 'package:design_system/src/theme/theme_port.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

void themePackages() {
  GetIt.I.registerLazySingleton<ThemePort>(ThemeAdapter.new);
}

final themePortProvider = Provider<ThemePort>((ref) => GetIt.I<ThemePort>());
