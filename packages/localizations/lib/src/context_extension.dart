import 'package:flutter/material.dart';
import 'package:localizations/src/app_localizations.dart';

extension TranslateExtension on BuildContext {
  String translate(String key, {Map<String, String>? args}) {
    return AppLocalizations.of(this).tr(key, args: args);
  }
}
