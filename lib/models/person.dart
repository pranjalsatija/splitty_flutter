import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Person {
  String name;

  Person.fromJSON(Map json) {
    name = json['name'];
  }

  static Future<File> get _storage async {
    final directory = await getApplicationDocumentsDirectory();
    return File(path.join(directory.path, 'people.json'));
  }

  static Future<List<Person>> get allPeople async {
    final storage = await _storage;
    String peopleString = await storage.readAsString();
    List people = json.decode(peopleString);
    return people.map((p) => Person.fromJSON(p)).toList();
  }
}