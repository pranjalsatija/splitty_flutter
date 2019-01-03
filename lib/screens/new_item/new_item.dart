import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/screens/new_item/new_item_form.dart';

class NewItemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).newItem),
      ),
      body: NewItemForm(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () { },
      ),
    );
  }
}