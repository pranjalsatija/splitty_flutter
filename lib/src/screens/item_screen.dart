import 'package:flutter/material.dart';
import 'package:splitty/src.dart';

class ItemScreen extends StatelessWidget {
  final Item item;

  final _formKey = GlobalKey<ItemFormState>();

  ItemScreen({
    @required this.item,
  });

  Widget _buildFloatingActionButton(BuildContext context, List<Person> people) {
    if (people == null || people.isEmpty) {
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

  Widget _buildBody(BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
    if (snapshot.hasError) {
      showErrorSnackbar(context, snapshot.error);
    }

    if (snapshot.hasData) {
      return ItemForm(
        item: item,
        key: _formKey,
        people: snapshot.data,
      );
    } else {
      PersonController.push();
      return ExpandedLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Person>>(
      stream: PersonController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(Strings.of(context).newItem),
          ),
          body: _buildBody(context, snapshot),
          floatingActionButton: _buildFloatingActionButton(context, snapshot.data),
        );
      },
    );
  }
}