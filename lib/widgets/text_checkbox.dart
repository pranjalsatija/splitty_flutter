import 'package:flutter/material.dart';

class TextCheckbox extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final String text;

  TextCheckbox({
    @required this.isSelected,
    @required this.onChanged,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: isSelected,
          onChanged: onChanged,
        ),
        Text(this.text,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ],
    );
  }
}