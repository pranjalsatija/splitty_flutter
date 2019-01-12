import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Strings {
  final Locale _locale;
  final _StringStorage _storage = _StringStorage();

  Strings(this._locale);

  Future<Strings> load() async {
    await _storage.load();
    return this;
  }

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  String interpolated(String key, List<dynamic> params) {
    String s = string(key);
    params.forEach((param) => s = s.replaceFirst('%s', param.toString()));
    return s;
  }

  String string(String key) {
    return _storage.string(key, _locale);
  }

  // Accessors
  String get addItemMessage => string('addItemMessage');
  String get addItemPrompt => string('addItemPrompt');
  String get addPersonMessage => string('addPersonMessage');
  String get addPersonPrompt => string('addPersonPrompt');
  String get appName => string('appName');
  String deletedItem(String name) => interpolated('deletedItem', [name]);
  String deletedPerson(String name) => interpolated('deletedPerson', [name]);
  String get done => string('done');
  String get existingSplits => string('existingSplits');
  String get invalidPrice => string('invalidPrice');
  String get itemInfo => string('itemInfo');
  String get itemName => string('itemName');
  String get itemPrice => string('itemPrice');
  String get missingName => string('missingName');
  String get newItem => string('newItem');
  String get newSplit => string('newSplit');
  String get noPeople => string('noPeople');
  String get noSelectedPeople => string('noSelectedPeople');
  String get people => string('people');
  String get personName => string('personName');
  String get selectAll => string('selectAll');
  String get undo => string('undo');
}

class _StringStorage {
  Map<String, dynamic> _strings;

  Future<void> load() async {
    final stringsJSON = await rootBundle.loadString('assets/strings.json');
    _strings = json.decode(stringsJSON) as Map<String, dynamic>;
  }

  String string(String key, Locale locale) {
    if (_strings[key] is String) {
      return _strings[key] as String;
    } else if (_strings[key] is Map<String, dynamic>) {
      final Map<String, dynamic> stringByLocale = _strings[key];
      return stringByLocale[locale.languageCode] as String;
    } else {
      return null;
    }
  }
}

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