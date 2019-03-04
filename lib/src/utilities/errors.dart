import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, Object error) {
  final snackbar = SnackBar(
    content: Text(error.toString()),
    backgroundColor: Theme.of(context).errorColor,
  );

  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(snackbar);
}