import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
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
  DateTime date;
  List<Item> items;
  String name;

  String get formattedDate => DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(0));

  Split({this.items, this.name});

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
  static Stream<Split> get currentSplitStream => _currentSplitStreamController.stream;
  static Stream<List<Split>> get allSplitsStream => _allSplitsStreamController.stream.map((splits) {
    splits.sort((a, b) => b.date.compareTo(a.date));
    return splits;
  });

  static List<Split> _allSplits;
  static Split _currentSplit;

  static final StreamController<List<Split>> _allSplitsStreamController = StreamController.broadcast();
  static final StreamController<Split> _currentSplitStreamController = StreamController.broadcast();

  static void addItemToCurrentSplit(Item item) {
    _loadCurrentSplitFromStorageIfNecessary().then((_) {
      _currentSplit.items.add(item);
      _currentSplitStreamController.add(_currentSplit);
      _synchronizeCurrentSplit();
    });
  }

  static void pushAllSplits() {
    _loadAllSplitsFromStorageIfNecessary().then((_) {
      _allSplitsStreamController.add(_allSplits);
    });
  }

  static void pushCurrentSplit() {
    _loadCurrentSplitFromStorageIfNecessary().then((_) {
      _currentSplitStreamController.add(_currentSplit);
    });
  }

  static void removeItemFromCurrentSplit(Item item) {
    _loadCurrentSplitFromStorageIfNecessary().then((_) {
      _currentSplit.items.remove(item);
      _currentSplitStreamController.add(_currentSplit);
      _synchronizeCurrentSplit();
    });
  }

  static void saveCurrentSplit(String name) {
    _currentSplit.date = DateTime.now();
    _currentSplit.name = name;

    _loadAllSplitsFromStorageIfNecessary().then((_) {
      _allSplits.add(_currentSplit);
      _allSplitsStreamController.add(_allSplits);
      _synchronizeAllSplits();
      _clearCurrentSplit();
    });
  }

  static Future<File> _allSplitStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, 'splits.json'));
    final exists = await file.exists();

    if (exists) {
      return file;
    } else {
      return file.create();
    }
  }

  static void _clearCurrentSplit() {
    _currentSplit = Split(
      items: [],
      name: null,
    );

    _currentSplitStreamController.add(_currentSplit);
    _synchronizeCurrentSplit();
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

  static Future<void> _loadAllSplitsFromStorageIfNecessary() async {
    if (_allSplits != null) {
      return;
    }

    final allSplitStorage = await _allSplitStorage();
    final allSplitsString = await allSplitStorage.readAsString();

    try {
      final allSplitBlobs = json.decode(allSplitsString) as List<dynamic>;
      final allSplitMaps = allSplitBlobs.map((dynamic b) => b as Map<String, dynamic>).toList();
      _allSplits = allSplitMaps.map((s) => Split.fromJson(s)).toList();
    } catch (e) {
      _allSplitsStreamController.addError(e);
      _allSplits = [];
    }
  }

  static Future<void> _loadCurrentSplitFromStorageIfNecessary() async {
    if (_currentSplit != null) {
      return;
    }

    final currentSplitStorage = await _currentSplitStorage();
    final currentSplitString = await currentSplitStorage.readAsString();

    try {
      final currentSplitJSON = json.decode(currentSplitString) as Map<String, dynamic>;
      _currentSplit = Split.fromJson(currentSplitJSON);
    } catch (e) {
      _currentSplitStreamController.addError(e);
      _currentSplit = Split(
        items: [],
        name: null,
      );
    }
  }

  static void _synchronizeAllSplits() async {
    try {
      final allSplitMaps = _allSplits.map((s) => s.toJson()).toList();
      final allSplitMapsString = json.encode(allSplitMaps);
      final storage = await _allSplitStorage();
      await storage.writeAsString(allSplitMapsString);
    } catch (e) {
      _allSplitsStreamController.addError(e);
    }
  }

  static void _synchronizeCurrentSplit() async {
    try {
      final storage = await _currentSplitStorage();
      await storage.writeAsString(json.encode(_currentSplit.toJson()));
    } catch (e) {
      _currentSplitStreamController.addError(e);
    }
  }
}