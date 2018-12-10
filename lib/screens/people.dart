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
        final snackbar = SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme
              .of(context)
              .errorColor,
        );

        Scaffold.of(context).showSnackBar(snackbar);
      }
    }
  }

  Future<String> _promptUserForName() {
    String textFieldContents;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Strings
              .of(context)
              .addPersonPrompt),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              labelText: Strings
                  .of(context)
                  .personName,
            ),
            onChanged: (value) => textFieldContents = value,
            onSubmitted: (_) => Navigator.pop(context, textFieldContents),
            textCapitalization: TextCapitalization.words,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, textFieldContents),
              child: Text(Strings
                  .of(context)
                  .done),
            ),
          ],
        );
      },
    );
  }

  void _showUndoDeleteSnackbar(Person person) {
    final snackbar = SnackBar(
      content: Text(Strings.of(context).deletedPerson(person.name)),
      action: SnackBarAction(
        label: Strings
            .of(context)
            .undo,
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

  Widget _buildAddButton() {
    return FloatingActionButton(
      child: Icon(Icons.person_add),
      onPressed: () => _addPerson(),
    );
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
          Text(
            Strings
                .of(context)
                .addPersonMessage,
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            color: Theme
                .of(context)
                .primaryColor,
            textColor: Colors.white,
            child: Text(Strings
                .of(context)
                .addPersonPrompt),
            onPressed: _addPerson,
          )
        ],
      ),
    );
  }

  Widget _buildPeopleList(List<Person> people) {
    if (people.isEmpty) {
      return _buildEmptyState();
    }

    final deletePerson = (int index) async {
      Person personToDelete = people[index];
      await PersonController.delete(personToDelete);
      _showUndoDeleteSnackbar(personToDelete);

      setState(() {
        _peopleFuture = PersonController.allPeople();
      });
    };

    return ListView.separated(
      itemCount: people.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(people[index].name),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme
                    .of(context)
                    .errorColor,
              ),
              onPressed: () => deletePerson(index),
            )
        );
      },
      separatorBuilder: (context, index) => Divider(height: 1.0),
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
              return snapshot.hasData
                  ? _buildPeopleList(snapshot.data)
                  : _buildEmptyState();
          }
        },
      ),
      floatingActionButton: _buildAddButton(),
      resizeToAvoidBottomPadding: false,
    );
  }
}