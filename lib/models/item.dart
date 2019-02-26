import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/utilities/_index.dart';

class Item {
  String name;
  List<Person> people = List();
  double price;

  String get formattedDescription {
    return '${ItemPriceInputFormatter.format(price, includeCurrencySymbol: true)}';
  }

  Item();

  Item.fromJSON(Map json) {
    this.name = json['name'];
    this.price = json['price'];
    this.people = (json['people'] as List).map((d) => Person.fromJSON(d)).toList();
  }

  Map toJSON() => {
    'name': this.name,
    'price': this.price,
    'people': this.people.map((p) => p.toJSON()).toList(),
  };


  @override
  bool operator ==(other) {
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
      parsedInput = NumberFormat.simpleCurrency().parse(text);
    } catch (error) {
      parsedInput = double.tryParse(text);
    }

    return parsedInput;
  }

  static String reformat(String text, {@required bool includeCurrencySymbol}) {
    double parsedInput = parse(text);

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