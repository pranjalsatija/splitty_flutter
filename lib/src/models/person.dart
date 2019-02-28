import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Person {
  String name;

  Person(this.name);

  Person.fromJSON(Map json) {
    name = json['name'];
  }

  Map toJSON() => {
    'name': name,
  };

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
}

class PersonController {
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


  static Future<List<Person>> allPeople() async {
    final storage = await _storage();
    final peopleString = await storage.readAsString();

    try {
      List peopleMaps = json.decode(peopleString);
      List people = peopleMaps.map((p) => Person.fromJSON(p)).toList();
      people.sort((a, b) => a.name.compareTo(b.name));
      return people;
    } catch (e) {
      return List();
    }
  }

  static Future<void> create(String name) async {
    final existingPeople = await allPeople();
    if (existingPeople.indexWhere((p) => p.name == name) != -1) {
      throw 'A person named $name already exists.';
    }

    existingPeople.add(Person(name));
    final newPeopleMaps = existingPeople.map((p) => p.toJSON()).toList();
    final newPeopleJSON = json.encode(newPeopleMaps);

    final storage = await _storage();
    await storage.writeAsString(newPeopleJSON);
  }

  static Future<void> delete(Person person) async {
    final existingPeople = await allPeople();
    existingPeople.removeWhere((p) => p.name == person.name);

    final newPeopleMaps = existingPeople.map((p) => p.toJSON()).toList();
    final newPeopleJSON = json.encode(newPeopleMaps);

    final storage = await _storage();
    await storage.writeAsString(newPeopleJSON);
  }
}