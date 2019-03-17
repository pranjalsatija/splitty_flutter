import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

typedef DeleteHandler = void Function(Item item);

class SplitList extends StatelessWidget {
  final DeleteHandler deleteHandler;
  final VoidCallback saveHandler;
  final bool shouldAllowEditing;
  final Split split;

  SplitList({
    @required this.deleteHandler,
    @required this.saveHandler,
    @required this.shouldAllowEditing,
    @required this.split,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: split.items.length + 1,
      itemBuilder: (context, index) {
        if (index >= split.items.length) {
          return SplitFooter(
            saveHandler: saveHandler,
            shouldAllowSave: shouldAllowEditing,
            split: split,
          );
        }

        final item = split.items[index];
        final buildListTileForItem = () {
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.formattedDescription(context)),
            onTap: shouldAllowEditing ? () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => ItemScreen(item: item, mode: ItemScreenMode.editItem),
                ),
              );
            } : null,
          );
        };

        if (shouldAllowEditing) {
          return Dismissible(
            child: buildListTileForItem(),
            key: Key(item.name),
            onDismissed: (_) => deleteHandler(item),
          );
        } else {
          return buildListTileForItem();
        }
      },
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }
}