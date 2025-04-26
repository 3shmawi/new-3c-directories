import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../enums/languages.dart';

extension Localizations on BuildContext {
  String translate(String key) {
    return key.tr();
  }

  bool isArabic() {
    return locale.languageCode == Languages.ar.code;
  }

  Future<void> changeLanguage(Languages language) async {
    await setLocale(Locale(language.code));
  }
}
