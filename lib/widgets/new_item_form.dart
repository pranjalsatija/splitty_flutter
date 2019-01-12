import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/utilities/_index.dart';
import 'package:splitty/widgets/_index.dart';

class NewItemForm extends StatefulWidget {
  final List<Person> people;

  NewItemForm({
    @required Key key,
    @required this.people,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewItemFormState();
}

class NewItemFormState extends State<NewItemForm> {
  final item = Item();

  final _formKey = GlobalKey<FormState>();
  final _nameTextFieldController = TextEditingController();
  final _priceTextFieldController = TextEditingController();
  final _priceTextFieldFocusNode = FocusNode();

  NewItemFormState() {
    _priceTextFieldFocusNode.addListener(_reformatPrice);
  }

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _priceTextFieldController.dispose();
    _priceTextFieldFocusNode.dispose();
    super.dispose();
  }

  void save() => _formKey.currentState.save();
  bool validate() => _formKey.currentState.validate();

  void _reformatPrice() {
    String text = _priceTextFieldController.text;
    _priceTextFieldController.text = ItemPriceInputFormatter.reformat(text);
  }

  Widget _buildItemInfoSectionBody(BuildContext context) {
    return FormSectionBody(
      padding: EdgeInsets.all(8),
      children: <Widget>[
        TextFormField(
          autofocus: true,
          controller: _nameTextFieldController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(0),
            isDense: true,
            labelText: Strings.of(context).itemName,
          ),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => Keyboard.of(context).focus(_priceTextFieldFocusNode),
          onSaved: (text) => item.name = text,
          validator: (input) => input.isEmpty ? Strings.of(context).missingName : null,
        ),
        TextFormField(
          controller: _priceTextFieldController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(0),
            isDense: true,
            labelText: Strings.of(context).itemPrice,
            prefix: Text(ItemPriceInputFormatter.currencySymbol),
          ),
          focusNode: _priceTextFieldFocusNode,
          keyboardType: TextInputType.number,
          onFieldSubmitted: (_) => Keyboard.of(context).dismiss(),
          onSaved: (text) => item.price = ItemPriceInputFormatter.parse(text),
          validator: (input) => ItemPriceInputFormatter.validate(input) ? null : Strings.of(context).invalidPrice,
        ),
      ],
    );
  }

  Widget _buildPeopleSectionBody(BuildContext context) {
    return FormSectionBody(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        MultiSelectFormField(
          builder: (index, state) {
            if (index == 0) {
              return TextCheckbox(
                onChanged: (newValue) {
                  state.didChange(List.filled(state.value.length, newValue));
                },
                text: Strings.of(context).selectAll,
                value: state.value.skip(1).every((v) => v),
              );
            } else {
              return TextCheckbox(
                onChanged: (newValue) {
                  state.value[index] = newValue;
                  state.didChange(state.value);
                },
                text: widget.people[index - 1].name,
                value: state.value[index],
              );
            }
          },
          numberOfItems: widget.people.length + 1,
          onSaved: (values) {
            item.people =  Map<int, Person>.fromIterable(
              widget.people.asMap().keys.where((i) => values[i]),
              value: (i) => widget.people[i],
            ).values.toList();
          },
          validator: (values) {
            if (values.contains(true)) {
              return null;
            } else {
              showErrorSnackbar(context, Strings.of(context).noSelectedPeople);
              return Strings.of(context).noSelectedPeople;
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.people.isEmpty) {
      return ListViewEmptyState(
        message: Strings.of(context).noPeople,
      );
    } else {
      return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            FormSection(
              title: Strings.of(context).itemInfo,
              body: _buildItemInfoSectionBody(context),
            ),
            FormSection(
              title: Strings.of(context).people,
              body: _buildPeopleSectionBody(context),
              padding: EdgeInsets.all(16),
            ),
          ],
        ),
      );
    }
  }
}