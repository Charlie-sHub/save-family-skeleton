import 'package:flutter/material.dart';

enum ThemeCode {
  backgroundPrimary,
  backgroundSecondary,
  textPrimary,
  textSecondary,
  buttonPrimary,
  buttonDisabled,
  border,
  error,
  success,
}

abstract class ThemePort {
  Map<ThemeCode, Color> get theme;

  Color colorFor(ThemeCode code) {
    final color = theme[code];
    if (color == null) {
      throw StateError('Theme key not found: $code');
    }
    return color;
  }
}
