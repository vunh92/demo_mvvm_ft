import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, ARABIC, VIETNAM }

const String ARABIC = "ar";
const String ENGLISH = "en";
const String VIETNAM = "vi";
const String ASSETS_PATH_LOCALISATIONS = "assets/translations";
const Locale ARABIC_LOCAL = Locale("ar","SA");
const Locale ENGLISH_LOCAL = Locale("en","US");
const Locale VIETNAM_LOCAL = Locale("vi","VN");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
      case LanguageType.VIETNAM:
        return VIETNAM;
    }
  }
}
