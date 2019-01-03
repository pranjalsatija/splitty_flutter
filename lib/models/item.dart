import 'package:intl/intl.dart';
import 'package:splitty/models/_index.dart';

class Item {
  String name;
  List<Person> people;
  double price;

  String get formattedDescription {
    // TODO: Return a real value here.
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
  static NumberFormat get formatter => NumberFormat.currency(symbol: '');

  static double _parse(String text) {
    double parsedInput;

    try {
      parsedInput = formatter.parse(text);
    } catch (error) {
      parsedInput = double.tryParse(text);
    }

    return parsedInput;
  }

  static String reformat(String text) {
    double parsedInput = _parse(text);

    if (parsedInput != null) {
      return formatter.format(parsedInput);
    } else {
      return text;
    }
  }

  static bool validate(String text) {
    return _parse(text) != null;
  }
}