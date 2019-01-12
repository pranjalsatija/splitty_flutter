import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:splitty/models/_index.dart';

class Split {
  List<Item> items;
  String name;
  String path;

  Split({this.items, this.name, this.path});

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
  static Future<File> _currentSplitStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, 'current_split.json'));
    final exists = await file.exists();

    if (exists) {
      return file;
    } else {
      return file.create();
    }
  }

  static Future<Split> currentSplit() async {
    final currentSplitStorage = await _currentSplitStorage();
    final currentSplitString = await currentSplitStorage.readAsString();

    try {
      Map currentSplitJSON = json.decode(currentSplitString);
      final split = Split.fromJSON(currentSplitJSON);
      split.path = currentSplitStorage.path;
      return split;
    } catch(e) {
      return Split(
        items: [],
        name: null,
        path: currentSplitStorage.path,
      );
    }
  }

  static Future<Split> addItem({
    Split split,
    Item item,
  }) async {
    split.items.add(item);
    final file = File(split.path);
    await file.writeAsString(json.encode(split.toJSON()));
    return split;
  }

  static Future<Split> deleteItem({
    Split split,
    Item item,
  }) async {
    split.items.remove(item);
    final file = File(split.path);
    await file.writeAsString(json.encode(split.toJSON()));
    return split;
  }
}