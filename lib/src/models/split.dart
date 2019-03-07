import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:splitty/splitty.dart';

part 'split.g.dart';

/*
Target API:

* SplitController.currentSplitStream gives you a stream to use to listen for changes to the current split.
* SplitController.push works like PersonController.push.
* SplitController.addItemToCurrentSplit lets you add an item to the current split. It emits a stream event.
* SplitController.removeItemFromCurrentSplit lets you remove an item from the current split. It emits a stream event.
 */

@JsonSerializable()
class Split {
  List<Item> items;
  String name;
  String path;

  Split({this.items, this.name, this.path});

  factory Split.fromJson(Map<String, dynamic> json) => _$SplitFromJson(json);
  Map toJson() => _$SplitToJson(this);

  Map<Person, double> totalsPerPerson() {
    final map = Map<Person, double>();

    for (final item in items) {
      final personalContribution = item.price / item.people.length;

      for (final person in item.people) {
        if (map.containsKey(person)) {
          map[person] += personalContribution;
        } else {
          map[person] = personalContribution;
        }
      }
    }

    return map;
  }
}

class SplitController {
  static Stream<Split> get currentSplitStream => _streamController.stream;

  static final StreamController<Split> _streamController = StreamController.broadcast();
  static Split _split;

  static void addItemToCurrentSplit(Item item) {
    _loadCurrentSplitFromStorageIfNecessary().then((_) {
      _split.items.add(item);
      _streamController.add(_split);
      _synchronizeCurrentSplit();
    });
  }

  static void removeItemFromCurrentSplit(Item item) {
    _loadCurrentSplitFromStorageIfNecessary().then((_) {
      _split.items.remove(item);
      _streamController.add(_split);
      _synchronizeCurrentSplit();
    });
  }

  static void push() {
    _loadCurrentSplitFromStorageIfNecessary().then((_) {
      _streamController.add(_split);
    });
  }

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

  static Future<void> _loadCurrentSplitFromStorageIfNecessary() async {
    if (_split != null) {
      return;
    }

    final currentSplitStorage = await _currentSplitStorage();
    final currentSplitString = await currentSplitStorage.readAsString();

    try {
      final currentSplitJSON = json.decode(currentSplitString) as Map<String, dynamic>;
      _split = Split.fromJson(currentSplitJSON);
      _split.path = currentSplitStorage.path;
    } catch(e) {
      _streamController.addError(e);
      _split = Split(
        items: [],
        name: null,
        path: currentSplitStorage.path,
      );
    }
  }

  static void _synchronizeCurrentSplit() async {
    try {
      final storage = await _currentSplitStorage();
      await storage.writeAsString(json.encode(_split.toJson()));
    } catch (e) {
      _streamController.addError(e);
    }
  }
}