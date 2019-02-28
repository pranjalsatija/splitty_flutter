import 'package:flutter/material.dart';

/// A widget that displays some text alongside a checkbox. The text's style is
/// automatically updated so that the text is bold when the widget is selected.
class TextCheckbox extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool value;
  final String text;

  TextCheckbox({
    @required this.onChanged,
    @required this.value,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        Text(text,
          style: TextStyle(
            fontWeight: value ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ],
    );
  }
}