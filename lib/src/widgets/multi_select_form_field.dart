import 'package:flutter/material.dart';

typedef MultiSelectFormFieldItemBuilder = Widget Function(int, FormFieldState<List<bool>>);
typedef MultiSelectFormFieldSelectAllBuilder = Widget Function(FormFieldState<List<bool>>);

class MultiSelectFormField extends FormField<List<bool>> {
  MultiSelectFormField({
    @required MultiSelectFormFieldItemBuilder builder,
    @required List<bool> initialValue,
    Key key,
    @required int numberOfItems,
    @required FormFieldSetter<List<bool>> onSaved,
    MultiSelectFormFieldSelectAllBuilder selectAllBuilder,
    @required FormFieldValidator<List<bool>> validator,
  }): super(
    builder: (state) {
      final widgets = state.value.asMap().map((index, value) {
        return MapEntry(index, builder(index, state));
      }).values.toList();
      widgets.insert(0, selectAllBuilder(state));

      return _MultiSelectFormFieldBody(
        widgets: widgets,
      );
    },
    key: key,
    initialValue: initialValue,
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
    final children = List<Widget>();
    widgets.take(widgets.length - 1).forEach((widget) {
      children.add(widget);
      children.add(Divider(height: 1));
    });

    children.add(widgets.last);

    return Column(
      children: children,
    );
  }
}