import 'package:flutter/material.dart';

typedef MultiSelectFormFieldItemBuilder = Widget Function(int, FormFieldState<List<bool>>);

class MultiSelectFormField extends FormField<List<bool>> {
  MultiSelectFormField({
    @required MultiSelectFormFieldItemBuilder builder,
    @required int numberOfItems,
    @required FormFieldSetter<List<bool>> onSaved,
    @required FormFieldValidator<List<bool>> validator,
  }): super(
    builder: (state) {
      final widgets = state.value.asMap().map((index, value) {
        return MapEntry(index, builder(index, state));
      }).values.toList();

      return _MultiSelectFormFieldBody(
        widgets: widgets,
      );
    },
    initialValue: List.filled(numberOfItems, false),
    onSaved: onSaved,
    validator: validator,
  );
}

class _MultiSelectFormFieldBody extends StatelessWidget {
  final List<Widget> widgets;

  _MultiSelectFormFieldBody({
    @required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    this.widgets.take(this.widgets.length - 1).forEach((widget) {
      children.add(widget);
      children.add(Divider(height: 1));
    });

    children.add(widgets.last);

    return Column(
      children: children,
    );
  }
}