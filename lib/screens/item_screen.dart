import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/widgets/item_form.dart';
import 'package:splitty/widgets/_index.dart';

class ItemScreen extends StatefulWidget {
  final Item item;

  ItemScreen({
    @required this.item,
  });

  @override
  State<StatefulWidget> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final _formKey = GlobalKey<ItemFormState>();

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
            Navigator.of(context).pop(_formKey.currentState.widget.item);
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
          return ItemForm(
            item: widget.item,
            key: _formKey,
            people: people,
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}