import 'package:design_system/src/theme/theme_port.dart';
import 'package:flutter/material.dart';

class ThemeAdapter extends ThemePort {
  @override
  Map<ThemeCode, Color> get theme => const {
        ThemeCode.backgroundPrimary: Color(0xFFFFFFFF),
        ThemeCode.backgroundSecondary: Color(0xFFF4F5F9),
        ThemeCode.textPrimary: Color(0xFF1A1B2E),
        ThemeCode.textSecondary: Color(0xFF6B6F87),
        ThemeCode.buttonPrimary: Color(0xFF4A6CF7),
        ThemeCode.buttonDisabled: Color(0xFFC8CBD9),
        ThemeCode.border: Color(0xFFE2E4ED),
        ThemeCode.error: Color(0xFFE5484D),
        ThemeCode.success: Color(0xFF2EBD85),
      };
}
