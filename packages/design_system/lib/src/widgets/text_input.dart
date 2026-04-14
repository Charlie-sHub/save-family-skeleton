import 'package:design_system/src/theme/theme_module.dart';
import 'package:design_system/src/theme/theme_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SfTextInput extends ConsumerWidget {
  const SfTextInput({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final String? hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final int? maxLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorFor(ThemeCode.textPrimary),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            counterText: '',
            filled: true,
            fillColor: theme.colorFor(ThemeCode.backgroundSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorFor(ThemeCode.border)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorFor(ThemeCode.border)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorFor(ThemeCode.buttonPrimary),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorFor(ThemeCode.error)),
            ),
          ),
        ),
      ],
    );
  }
}
