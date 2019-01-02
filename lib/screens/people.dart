import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/person.dart';
import 'package:splitty/screens/main_tab.dart';
import 'package:splitty/widgets/_index.dart';

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

  /// Used with CachingFutureBuilder.
  List<Person> _people;

  _PeopleScreenState() {
    _peopleFuture = PersonController.allPeople();
  }

  void _addPerson() async {
    final result = await _promptUserForName();
    if (result != null && result.isNotEmpty) {
      try {
        await PersonController.create(result);

        setState(() {
          _peopleFuture = PersonController.allPeople();
        });
      } catch (e) {
        _showErrorSnackbar(e);
      }
    }
  }

  void _deletePerson(Person person) async {
    await PersonController.delete(person);
    _showUndoDeleteSnackbar(person);

    setState(() {
      _peopleFuture = PersonController.allPeople();
    });
  }

  Future<String> _promptUserForName() {
    String textFieldContents;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Strings.of(context).addPersonPrompt),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              labelText: Strings.of(context).personName,
            ),
            onChanged: (value) => textFieldContents = value,
            onSubmitted: (_) => Navigator.pop(context, textFieldContents),
            textCapitalization: TextCapitalization.words,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, textFieldContents),
              child: Text(Strings.of(context).done),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackbar(Object error) {
    final snackbar = SnackBar(
      content: Text(error.toString()),
      backgroundColor: Theme.of(context).errorColor,
    );

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void _showUndoDeleteSnackbar(Person person) {
    final snackbar = SnackBar(
      content: Text(Strings.of(context).deletedPerson(person.name)),
      action: SnackBarAction(
        label: Strings.of(context).undo,
        onPressed: () async {
          await PersonController.create(person.name);
          setState(() {
            _peopleFuture = PersonController.allPeople();
          });
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  Widget _buildPersonListTile(Person person) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 0),
      title: Text(person.name),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).errorColor,
        ),
        onPressed: () => _deletePerson(person),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).people),
      ),
      body: CachingFutureBuilder<List<Person>>(
        future: _peopleFuture,
        cachedData: _people,
        cacheSaver: (people) => _people = people,
        loadingWidgetBuilder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        finishedWidgetBuilder: (context, people, error) {
          if (error != null) {
            _showErrorSnackbar(error);
          }

          if (people == null || people.isEmpty) {
            return ListViewEmptyState(
              actionText: Strings.of(context).addPersonPrompt,
              message: Strings.of(context).addPersonMessage,
              onPressed: () => _addPerson(),
            );
          } else {
            return ListView.separated(
              itemCount: people.length,
              itemBuilder: (context, index) => _buildPersonListTile(people[index]),
              separatorBuilder: (context, index) => Divider(height: 1.0),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () => _addPerson(),
      ),
    );
  }
}