import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/item.dart';
import 'package:splitty/utilities/keyboard.dart';
import 'package:splitty/widgets/_index.dart';

class NewItemScreen extends StatefulWidget {
  final _priceTextFieldController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _priceTextFieldController = TextEditingController();
  final _priceTextFieldFocusNode = FocusNode();

  bool _isSelected = false;
  
  _NewItemScreenState() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).newItem),
      ),
      body: SectionedForm(
        sections: [
          FormSection(
            title: Strings.of(context).itemInfo,
            body: FormSectionBody(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    labelText: Strings.of(context).itemName,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => Keyboard.of(context).focus(_priceTextFieldFocusNode),
                ),
                TextFormField(
                  controller: _priceTextFieldController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    labelText: Strings.of(context).itemPrice,
                    prefix: Text(ItemPriceInputFormatter.currencySymbol),
                  ),
                  focusNode: _priceTextFieldFocusNode,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) => Keyboard.of(context).dismiss(),
                ),
              ],
            ),
          ),
          FormSection(
            title: Strings.of(context).people,
            body: FormSectionBody(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                TextCheckbox(
                  isSelected: _isSelected,
                  onChanged: (newValue) => setState(() {
                    _isSelected = newValue;
                  }),
                  text: 'Test Checkbox',
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () { },
      ),
    );
  }
}
