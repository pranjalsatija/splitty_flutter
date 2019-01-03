import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/utilities/_index.dart';
import 'package:splitty/widgets/_index.dart';

class NewItemForm extends StatefulWidget {
  final Key formKey;
  final VoidCallback onChanged;
  final List<Person> people;

  NewItemForm({
    @required this.formKey,
    this.onChanged,
    @required this.people,
  });

  @override
  State<StatefulWidget> createState() => _NewItemFormState(
    formKey: formKey,
    onChanged: onChanged,
    people: people,
  );
}

class _NewItemFormState extends State<NewItemForm> {
  final Key formKey;
  final VoidCallback onChanged;
  final List<Person> people;

  _NewItemFormState({
    @required this.formKey,
    this.onChanged,
    @required this.people
  });

  Widget form;

  @override
  Widget build(BuildContext context) {
    return SectionedForm(
      formKey: formKey,
      onChanged: onChanged,
      sections: <Widget>[
        _ItemInfoSection(),
        _PeopleSection(people),
      ],
    );
  }
}


class _ItemInfoSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemInfoSectionState();
}

class _ItemInfoSectionState extends State<_ItemInfoSection> {
  final _priceTextFieldController = TextEditingController();
  final _priceTextFieldFocusNode = FocusNode();

  _ItemInfoSectionState() {
    _priceTextFieldFocusNode.addListener(_reformatPrice);
  }

  @override
  void dispose() {
    _priceTextFieldController.dispose();
    _priceTextFieldFocusNode.dispose();
    super.dispose();
  }

  void _reformatPrice() {
    String text = _priceTextFieldController.text;
    _priceTextFieldController.text = ItemPriceInputFormatter.reformat(text);
  }

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: Strings.of(context).itemInfo,
      body: FormSectionBody(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              isDense: true,
              labelText: Strings.of(context).itemName,
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => Keyboard.of(context).focus(_priceTextFieldFocusNode),
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
            validator: (input) => ItemPriceInputFormatter.validate(input) ? null : Strings.of(context).invalidPrice,
          ),
        ],
      ),
    );
  }
}


class _PeopleSection extends FormField<Set<Person>> {
  final List<Person> people;

  _PeopleSection(this.people) : super(
    initialValue: Set(),
    builder: (state) {
      return _PeopleSectionBody(
        formFieldState: state,
        people: people,
      );
    },
    validator: (selectedPeople) => selectedPeople.isEmpty ? 'Invalid' : null,
  );
}

class _PeopleSectionBody extends StatelessWidget {
  final FormFieldState<Set<Person>> formFieldState;
  final List<Person> people;
  
  _PeopleSectionBody({
    this.formFieldState,
    this.people,
  });

  void _deselect(Person person) => formFieldState.didChange(formFieldState.value..remove(person));
  void _deselectAll() => formFieldState.didChange(formFieldState.value..clear());
  void _select(Person person) => formFieldState.didChange(formFieldState.value..add(person));
  void _selectAll() => formFieldState.didChange(formFieldState.value..addAll(people));

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = people.asMap().map((index, person) {
      final checkbox = TextCheckbox(
        isSelected: formFieldState.value.contains(person),
        onChanged: (newValue) => newValue ? _select(person) : _deselect(person),
        text: person.name,
      );

      return MapEntry(index, checkbox);
    }).values.toList();

    final selectAllCheckbox = TextCheckbox(
      isSelected: formFieldState.value.containsAll(people),
      onChanged: (newValue) => newValue ? _selectAll() : _deselectAll(),
      text: Strings.of(context).selectAll,
    );

    children.insert(0, selectAllCheckbox);

    // TODO: Display something when formFieldState.hasError?

    return FormSection(
      title: Strings.of(context).people,
      body: FormSectionBody(
        children: children,
        padding: EdgeInsets.all(0),
      ),
    );
  }
}