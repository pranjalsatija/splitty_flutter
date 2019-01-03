import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/item.dart';
import 'package:splitty/models/person.dart';
import 'package:splitty/utilities/keyboard.dart';
import 'package:splitty/widgets/_index.dart';

class NewItemForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewItemFormState();
}

class _NewItemFormState extends State<NewItemForm> {
  Future<List<Person>> _peopleFuture = PersonController.allPeople();

  @override
  Widget build(BuildContext context) {
    return SimpleFutureBuilder<List<Person>>(
      future: _peopleFuture,
      loadingWidgetBuilder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      finishedWidgetBuilder: (context, people, error) {
        if (people != null && people.isNotEmpty) {
          return SectionedForm(
            sections: <Widget>[
              _ItemInfoSection(),
              _PeopleSection(people),
            ],
          );
        } else {
          return ListViewEmptyState(
            message: Strings.of(context).noPeople,
          );
        }
      },
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
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              errorBorder: InputBorder.none,
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
              errorBorder: InputBorder.none,
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


class _PeopleSection extends StatefulWidget {
  final List<Person> _people;

  _PeopleSection(this._people);

  @override
  State<StatefulWidget> createState() => _PeopleSectionState(_people);
}

class _PeopleSectionState extends State<_PeopleSection> {
  List<Person> _people;
  Set<Person> _selectedPeople = Set();

  _PeopleSectionState(this._people);

  void _deselect(Person person) => setState(() {
    _selectedPeople.remove(person);
  });

  void _deselectAll() => setState(() {
    _selectedPeople.clear();
  });

  void _select(Person person) => setState(() {
    _selectedPeople.add(person);
  });

  void _selectAll() => setState(() {
    _selectedPeople.addAll(_people);
  });

  @override
  Widget build(BuildContext context) {
    final children = _people.asMap().map((index, person) {
      final checkbox = TextCheckbox(
        isSelected: _selectedPeople.contains(person),
        onChanged: (newValue) => newValue ? _select(person) : _deselect(person),
        text: person.name,
      );

      return MapEntry(index, checkbox);
    }).values.toList();

    final selectAllCheckbox = TextCheckbox(
      isSelected: _selectedPeople.containsAll(_people),
      onChanged: (newValue) => newValue ? _selectAll() : _deselectAll(),
      text: Strings.of(context).selectAll,
    );

    children.insert(0, selectAllCheckbox);

    return FormSection(
      title: Strings.of(context).people,
      body: FormSectionBody(
        children: children,
        padding: EdgeInsets.all(0),
      ),
    );
  }
}