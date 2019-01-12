import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/widgets/new_item_form.dart';
import 'package:splitty/widgets/_index.dart';

class NewItemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<NewItemFormState>();

  final _peopleFuture = PersonController.allPeople();
  List<Person> _people;

  Widget _buildFloatingActionButton() {
    if (_people == null || _people.isEmpty) {
      return null;
    } else {
      return FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context).pop(_formKey.currentState.item);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).newItem),
      ),
      body: SimpleFutureBuilder<List<Person>>(
        cacheSaver: (people) => _people = people,
        future: _peopleFuture,
        loadingWidgetBuilder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        finishedWidgetBuilder: (context, people, error) {
          return NewItemForm(
            key: _formKey,
            people: people,
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}