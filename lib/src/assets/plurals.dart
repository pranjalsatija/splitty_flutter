import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plurals.g.dart';

class PluralFormatter {
  static Map<String, List<_LocalizedPluralFormatter>> _formatters = Map();

  PluralFormatter(String plurals) {
    final pluralsJSON = json.decode(plurals) as Map<String, dynamic>;
    pluralsJSON.forEach((languageCode, dynamic rawFormatterJSON) {
      final formatterJSON = rawFormatterJSON as List<dynamic>;
      final formatters = formatterJSON.map((dynamic j) {
        final formatterMap = j as Map<String, dynamic>;
        return _LocalizedPluralFormatter.fromJson(formatterMap);
      }).toList();

      _formatters[languageCode] = formatters;
    });
  }

  String format(List<Object> objects, Locale locale) {
    final formatters = _formatters[locale.languageCode].where((f) => f.canFormat(objects)).toList();
    assert(formatters.length == 1);
    return formatters.first.format(objects);
  }
}

@JsonSerializable()
class _LocalizedPluralFormatter {
  int minLength;
  int maxLength;
  String separator;
  String finalSeparator;

  _LocalizedPluralFormatter();

  factory _LocalizedPluralFormatter.fromJson(Map<String, dynamic> json) => _$_LocalizedPluralFormatterFromJson(json);
  Map toJson() => _$_LocalizedPluralFormatterToJson(this);

  bool canFormat(List<Object> objects) {
    return objects.length >= minLength && objects.length <= maxLength;
  }

  String format(List<Object> objects) {
    assert(objects.length >= minLength && objects.length <= maxLength);

    final buffer = StringBuffer();

    for (var i = 0; i < objects.length; i++) {
      buffer.write(objects[i]);

      if (i == objects.length - 2) {
        buffer.write(finalSeparator);
      } else if (i < objects.length - 1) {
        buffer.write(separator);
      }
    }

    return buffer.toString();
  }
}