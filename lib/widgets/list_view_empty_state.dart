import 'package:flutter/material.dart';

class ListViewEmptyState extends StatelessWidget {
  final String actionText;
  final String message;
  final VoidCallback onPressed;

  ListViewEmptyState({this.actionText, this.message, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text(actionText),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}