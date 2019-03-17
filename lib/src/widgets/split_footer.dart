import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

class SplitFooter extends StatelessWidget {
  final VoidCallback saveHandler;
  final bool shouldAllowSave;
  final Split split;

  SplitFooter({
    @required this.saveHandler,
    @required this.shouldAllowSave,
    @required this.split,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = split.totalsPerPerson().map<Person, Widget>((person, amount) {
      final formattedAmount = ItemPriceInputFormatter.format(amount, includeCurrencySymbol: true);
      final formattedDisplay = Strings.of(context).splitFormattedDisplay(person.toString(), formattedAmount);

      final textWidget = Text(
        formattedDisplay,
        style: TextStyle(
            fontWeight: FontWeight.bold
        ),
      );

      return MapEntry(person, textWidget);
    }).values.toList();

    if (shouldAllowSave) {
      widgets.add(
        RaisedButton(
          child: Text(Strings.of(context).saveSplit),
          color: Theme.of(context).primaryColor,
          onPressed: saveHandler,
          textColor: Colors.white,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: widgets,
      ),
    );
  }
}