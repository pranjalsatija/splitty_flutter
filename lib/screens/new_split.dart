import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/screens/new_item.dart';
import 'package:splitty/widgets/_index.dart';

import 'main_tab.dart';

class NewSplitScreen extends StatefulWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.add),
      title: Text(Strings.of(context).newSplit),
    );
  }

  @override
  State<StatefulWidget> createState() => _NewSplitScreenState();
}

class _NewSplitScreenState extends State<NewSplitScreen> {
  Future<Split> _currentSplitFuture;
  Split _currentSplit;

  bool _switchValue = false;

  _NewSplitScreenState() {
    _currentSplitFuture = SplitController.currentSplit();
  }

  void _addItem(Item item) async {
    final Item newItem = item ?? await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NewItemScreen()),
    );

    if (newItem != null) {
      setState(() {
        _currentSplitFuture = SplitController.addItem(
          item: newItem,
          split: _currentSplit,
        );
      });
    }
  }

  void _deleteItem(Item item) async {
    _showUndoDeleteSnackbar(item);

    setState(() {
      _currentSplit.items.remove(item);
      _currentSplitFuture = SplitController.deleteItem(
        item: item,
        split: _currentSplit,
      );
    });
  }

  void _showUndoDeleteSnackbar(Item item) {
    final snackbar = SnackBar(
      content: Text(Strings.of(context).deletedItem(item.name)),
      action: SnackBarAction(
        label: Strings.of(context).undo,
        onPressed: () => _addItem(item),
      ),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  Widget _buildItemListTile(Item item) {
    return Dismissible(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(item.formattedDescription),
        onTap: () {
          print('Tapped ${item.name}.');
          // TODO: Present a details screen for the item.
        },
      ),
      key: Key(item.name),
      onDismissed: (_) => _deleteItem(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).newSplit),
      ),
      body: SimpleFutureBuilder<Split>(
        future: _currentSplitFuture,
        cachedData: _currentSplit,
        cacheSaver: (currentSplit) => _currentSplit = currentSplit,
        loadingWidgetBuilder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        finishedWidgetBuilder: (context, currentSplit, error) {
          if (currentSplit == null || currentSplit.items.isEmpty) {
            return ListViewEmptyState(
              actionText: Strings.of(context).addItemPrompt,
              message: Strings.of(context).addItemMessage,
              onPressed: () => _addItem(null),
            );
          } else {
            return ListView.separated(
              itemCount: currentSplit.items.length,
              itemBuilder: (context, index) =>
                  _buildItemListTile(currentSplit.items[index]),
              separatorBuilder: (context, index) => Divider(height: 1.0),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addItem(null),
      ),
    );
  }
}
