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
    var s = string(key);
    params.forEach((dynamic param) => s = s.replaceFirst('%s', param.toString()));
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
  String deletedItem(String name) => interpolated('deletedItem', <String>[name]);
  String deletedPerson(String name) => interpolated('deletedPerson', <String>[name]);
  String get done => string('done');
  String get editItem => string('editItem');
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
  String get saveSplitInstructions => string('saveSplitInstructions');
  String get saveSplitPrompt => string('saveSplitPrompt');
  String get saveSplit => string('saveSplit');
  String savedSplit(String name) => interpolated('savedSplit', <String>[name]);
  String get selectAll => string('selectAll');
  String get splitName => string('splitName');
  String get undo => string('undo');
  String get viewItem => string('viewItem');
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
      final stringByLocale = _strings[key] as Map<String, dynamic>;
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