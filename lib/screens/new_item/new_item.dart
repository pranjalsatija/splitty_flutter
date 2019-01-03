import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/screens/new_item/new_item_form.dart';
import 'package:splitty/widgets/_index.dart';

class NewItemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _peopleFuture = PersonController.allPeople();

  void _save() {
    if (!_formKey.currentState.validate()) {
      return;
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).newItem),
      ),
      body: SimpleFutureBuilder<List<Person>>(
        future: _peopleFuture,
        loadingWidgetBuilder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        finishedWidgetBuilder: (context, people, error) {
          return NewItemForm(
            formKey: _formKey,
            people: people,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _save,
      ),
    );
  }
}