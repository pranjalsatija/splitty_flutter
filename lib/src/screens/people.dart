import 'package:flutter/material.dart';
import 'package:splitty/src.dart';

class PeopleScreen extends StatelessWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: Text(Strings.of(context).people),
    );
  }

  void _addPerson(BuildContext context, String name) async {
    final result = name ?? await _promptUserForName(context);

    if (result != null && result.isNotEmpty) {
      PersonController.add(Person(result));
    }
  }

  void _deletePerson(BuildContext context, Person person) {
    PersonController.remove(person);
    _showUndoDeleteSnackbar(context, person);
  }

  Future<String> _promptUserForName(BuildContext context) {
    String textFieldContents;

    return showDialog(
      context: context,
      builder: (context) {
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

  void _showUndoDeleteSnackbar(BuildContext context, Person person) {
    final snackbar = SnackBar(
      content: Text(Strings.of(context).deletedPerson(person.name)),
      action: SnackBarAction(
        label: Strings.of(context).undo,
        onPressed: () => _addPerson(context, person.name),
      ),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  Widget _buildPeopleList(BuildContext context, List<Person> people) {
    if (people.isEmpty) {
      return ListViewEmptyState(
        actionText: Strings.of(context).addPersonPrompt,
        message: Strings.of(context).addPersonMessage,
        onPressed: () => _addPerson(context, null),
      );
    }

    return ListView.separated(
      itemCount: people.length,
      itemBuilder: (context, index) {
        final person = people[index];

        return Dismissible(
          key: Key(person.name),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 16, right: 0),
            title: Text(person.name),
          ),
          onDismissed: (_) {
            _deletePerson(context, person);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(height: 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    PersonController.push();

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).people),
      ),
      body: StreamBuilder<List<Person>>(
        stream: PersonController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrorSnackbar(context, snapshot.error);
          }

          if (snapshot.hasData) {
            return _buildPeopleList(context, snapshot.data);
          } else {
            return ExpandedLoadingIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () => _addPerson(context, null),
      ),
    );
  }
}