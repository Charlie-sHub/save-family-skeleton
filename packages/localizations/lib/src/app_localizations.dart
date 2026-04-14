import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  late Map<String, String> _strings;

  static const List<String> supportedLanguages = ['en', 'es'];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
  ];

  static const List<LocalizationsDelegate<dynamic>> delegates = [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (localizations == null) {
      throw FlutterError('AppLocalizations not found in context');
    }
    return localizations;
  }

  Future<void> load() async {
    final raw = await rootBundle.loadString(
      'packages/localizations/assets/l10n/${locale.languageCode}.json',
    );
    final decoded = json.decode(raw) as Map<String, dynamic>;
    _strings = decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  String tr(String key, {Map<String, String>? args}) {
    var value = _strings[key] ?? key;
    if (args != null) {
      args.forEach((argKey, argValue) {
        value = value.replaceAll('{$argKey}', argValue);
      });
    }
    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
