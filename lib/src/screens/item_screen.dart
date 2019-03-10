import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

enum ItemScreenMode {
  newItem, editItem, viewItem
}

class ItemScreen extends StatefulWidget {
  final Item item;
  final ItemScreenMode mode;

  ItemScreen({
    @required this.item,
    @required this.mode,
  });

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final _formKey = GlobalKey<ItemFormState>();

  Widget _buildFloatingActionButton(BuildContext context, List<Person> people) {
    if (people == null || people.isEmpty || widget.mode == ItemScreenMode.viewItem) {
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
        key: _formKey,
        item: widget.item,
        people: snapshot.data,
      );
    } else {
      PersonController.push();
      return ExpandedLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title;

    switch (widget.mode) {
      case ItemScreenMode.newItem:
        title = Strings.of(context).newItem;
        break;
      case ItemScreenMode.editItem:
        title = Strings.of(context).editItem;
        break;
      case ItemScreenMode.viewItem:
        title = Strings.of(context).viewItem;
        break;
    }

    return StreamBuilder<List<Person>>(
      stream: PersonController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: _buildBody(context, snapshot),
          floatingActionButton: _buildFloatingActionButton(context, snapshot.data),
        );
      },
    );
  }
}