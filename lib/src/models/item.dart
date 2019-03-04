import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:splitty/splitty.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  String name;
  List<Person> people = List();
  double price;

  String get formattedDescription {
    return '${ItemPriceInputFormatter.format(price, includeCurrencySymbol: true)}';
  }

  Item();

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map toJson() => _$ItemToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is Item) {
      return other.name == name && other.price == price;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => hash2(name, price);
}

class ItemPriceInputFormatter {
  static String get currencySymbol => NumberFormat.simpleCurrency().currencySymbol;

  static String format(double value, {@required bool includeCurrencySymbol}) {
    if (includeCurrencySymbol) {
      return NumberFormat.simpleCurrency().format(value);
    } else {
      return NumberFormat.currency(symbol: '').format(value);
    }
  }

  static double parse(String text) {
    double parsedInput;

    try {
      parsedInput = NumberFormat.simpleCurrency().parse(text).toDouble();
    } catch (error) {
      parsedInput = double.tryParse(text);
    }

    return parsedInput;
  }

  static String reformat(String text, {@required bool includeCurrencySymbol}) {
    final parsedInput = parse(text);

    if (parsedInput != null && includeCurrencySymbol) {
      return NumberFormat.currency(symbol: '').format(parsedInput);
    } else if (parsedInput != null) {
      return NumberFormat.simpleCurrency().format(parsedInput);
    } else {
      return text;
    }
  }

  static bool validate(String text) {
    return parse(text) != null;
  }
}