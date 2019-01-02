import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:splitty/models/item.dart';

class Split {
  List<Item> items;
  String name;

  Split({this.items, this.name});

  Split.fromJSON(Map json) {
    name = json['name'];
    items = (json['items'] as List).map((d) => Item.fromJSON(d)).toList();
  }

  Map toJSON() => {
    'name': this.name,
    'items': this.items.map((i) => i.toJSON()).toList(),
  };
}

class SplitController {
  static Future<Split> currentSplit() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, 'current_split.json'));
    final exists = await file.exists();

    if (exists) {
      String existingSplitString = await file.readAsString();
      Map existingSplitJSON = json.decode(existingSplitString);
      return Split.fromJSON(existingSplitJSON);
    } else {
      return Split(
        items: [],
        name: null
      );
    }
  }
}