import 'package:flutter/material.dart';

import 'package:splitty/assets/strings/strings.dart';
import 'package:splitty/models/person.dart';
import 'package:splitty/screens/main_tab.dart';

class PeopleScreen extends StatefulWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: Text(Strings.of(context).people),
    );
  }

  @override
  State<StatefulWidget> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  Future<List<Person>> _peopleFuture;

  _PeopleScreenState() {
    _peopleFuture = Person.allPeople;
  }

  Widget _buildCircularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Strings.of(context).addPerson),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).people),
      ),
      body: FutureBuilder(
        future: _peopleFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _buildCircularProgressIndicator();

            case ConnectionState.done:
            default:
              return snapshot.hasData ? null : _buildEmptyState();
          }
        },
      ),
    );
  }
}