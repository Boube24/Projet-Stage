import 'package:flutter/material.dart';

class LocaleProvider
    extends ChangeNotifier {

  Locale _locale =
  const Locale(
    "fr",
  );

  Locale get locale =>
      _locale;

  void changeLanguage(
      String code,
      ){

    _locale =
        Locale(
          code,
        );

    notifyListeners();

  }

}