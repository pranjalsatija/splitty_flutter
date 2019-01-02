import 'package:intl/intl.dart';
import 'package:splitty/models/person.dart';

class Item {
  String name;
  List<Person> people;
  double price;

  String get formattedDescription {
    return '\$X.Y · Everyone';
  }

  Item({this.name, this.people, this.price});

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
}

class ItemPriceInputFormatter {
  static String get currencySymbol => NumberFormat.simpleCurrency().currencySymbol;

  static reformat(String text) {
    final formatter = NumberFormat.currency(symbol: '');
    double parsedInput;

    try {
      parsedInput = NumberFormat.simpleCurrency().parse(text);
    } catch (error) {
      parsedInput = double.tryParse(text);
    }

    if (parsedInput != null) {
      return formatter.format(parsedInput);
    } else {
      return text;
    }
  }
}