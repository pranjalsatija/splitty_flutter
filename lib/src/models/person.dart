import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  String name;

  Person(this.name);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map toJson() => _$PersonToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is Person) {
      return name == other.name;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

class PersonController {
  static Stream<List<Person>> get stream => _streamController.stream.map((people) {
    people.sort((a, b) => a.name.compareTo(b.name));
    return people;
  });

  static final StreamController<List<Person>> _streamController = StreamController.broadcast();
  static List<Person> _people;

  static void add(Person person) {
    _loadFromStorageIfNecessary().then((_) {
      if (!_people.contains(person)) {
        _people.add(person);
        _streamController.add(_people);
        _synchronize();
      }
    });
  }

  static void remove(Person person) {
    _loadFromStorageIfNecessary().then((_) {
      _people.remove(person);
      _streamController.add(_people);
      _synchronize();
    });
  }

  static void push() {
    _loadFromStorageIfNecessary().then((_) {
      _streamController.add(_people);
    });
  }

  static Future<void> _loadFromStorageIfNecessary() async {
    if (_people != null) {
      return;
    }

    try {
      final storage = await _storage();
      final peopleString = await storage.readAsString();

      final peopleBlobs = json.decode(peopleString) as List<dynamic>;
      final peopleMaps = peopleBlobs.map((dynamic p) => p as Map<String, dynamic>).toList();
      final people = peopleMaps.map((p) => Person.fromJson(p)).toList();
      people.sort((a, b) => a.name.compareTo(b.name));
      _people = people;
    } catch (e) {
      _streamController.addError(e);
      _people = List();
    }
  }

  static Future<File> _storage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, 'people.json'));
    final exists = await file.exists();

    if (exists) {
      return file;
    } else {
      return file.create();
    }
  }

  static void _synchronize() async {
    try {
      final peopleMaps = _people.map((p) => p.toJson()).toList();
      final peopleMapsString = json.encode(peopleMaps);
      final storage = await _storage();
      await storage.writeAsString(peopleMapsString);
    } catch (e) {
      _streamController.addError(e);
    }
  }
}