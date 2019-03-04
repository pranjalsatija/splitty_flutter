import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:splitty/splitty.dart';

part 'split.g.dart';

@JsonSerializable()
class Split {
  List<Item> items;
  String name;
  String path;

  Split({this.items, this.name, this.path});

  factory Split.fromJson(Map<String, dynamic> json) => _$SplitFromJson(json);
  Map toJson() => _$SplitToJson(this);
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
      final currentSplitJSON = json.decode(currentSplitString) as Map<String, dynamic>;
      final split = Split.fromJson(currentSplitJSON);
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
    await file.writeAsString(json.encode(split.toJson()));
    return split;
  }

  static Future<Split> deleteItem({
    Split split,
    Item item,
  }) async {
    split.items.remove(item);
    final file = File(split.path);
    await file.writeAsString(json.encode(split.toJson()));
    return split;
  }
}