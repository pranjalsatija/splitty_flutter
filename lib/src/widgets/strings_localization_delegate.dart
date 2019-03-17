import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

class StringsLocalizationDelegate extends LocalizationsDelegate<Strings> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<Strings> load(Locale locale) {
    return Strings(locale).load();
  }

  @override
  bool shouldReload(LocalizationsDelegate<Strings> old) => false;
}