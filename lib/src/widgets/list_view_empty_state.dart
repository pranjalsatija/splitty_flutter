import 'package:flutter/material.dart';

/// This widget is used to show an empty state in lieu of a blank list.
/// It can be configured to show some text, along with a button for the user to
/// take action, usually to create some data to populate the list.
class ListViewEmptyState extends StatelessWidget {
  /// The text to display in the button. If this is not provided,
  /// the button will be hidden.
  final String actionText;

  /// The message to display to the user.
  final String message;

  /// The callback to call when the button is pressed.
  final VoidCallback onPressed;

  /// The padding to put around the text and button.
  final EdgeInsets padding;

  ListViewEmptyState({
    this.actionText,
    @required this.message,
    this.onPressed,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(
        message,
        textAlign: TextAlign.center,
      ),
    ];

    if (actionText != null) {
      children.add(
        RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text(actionText),
          onPressed: onPressed,
        ),
      );
    }

    return Container(
      alignment: Alignment(0, 0),
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}