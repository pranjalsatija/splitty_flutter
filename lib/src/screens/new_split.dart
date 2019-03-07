import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

import 'main_tab.dart';

class NewSplitScreen extends StatelessWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.add),
      title: Text(Strings.of(context).newSplit),
    );
  }

  void _addItem(BuildContext context, Item item) async {
    final newItem = item ?? await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemScreen(
          item: Item(),
        ),
      ),
    );

    if (newItem != null) {
      SplitController.addItemToCurrentSplit(newItem);
    }
  }

  void _deleteItem(BuildContext context, Item item) async {
    _showUndoDeleteSnackbar(context, item);
    SplitController.removeItemFromCurrentSplit(item);
  }

  void _showUndoDeleteSnackbar(BuildContext context, Item item) {
    final snackbar = SnackBar(
      content: Text(Strings.of(context).deletedItem(item.name)),
      action: SnackBarAction(
        label: Strings.of(context).undo,
        onPressed: () => _addItem(context, item),
      ),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  Widget _buildSplitList(BuildContext context, Split split) {
    if (split.items.isEmpty) {
      return ListViewEmptyState(
        actionText: Strings.of(context).addItemPrompt,
        message: Strings.of(context).addItemMessage,
        onPressed: () => _addItem(context, null),
      );
    }

    return ListView.separated(
      itemCount: split.items.length,
      itemBuilder: (context, index) {
        final item = split.items[index];

        return Dismissible(
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.formattedDescription),
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                    builder: (context) => ItemScreen(item: item)
                ),
              );
            },
          ),
          key: Key(item.name),
          onDismissed: (_) => _deleteItem(context, item),
        );
      },
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).newSplit),
      ),
      body: StreamBuilder<Split>(
        stream: SplitController.currentSplitStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrorSnackbar(context, snapshot.error);
          }

          if (snapshot.hasData) {
            return _buildSplitList(context, snapshot.data);
          } else {
            SplitController.push();
            return ExpandedLoadingIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addItem(context, null),
      ),
    );
  }
}