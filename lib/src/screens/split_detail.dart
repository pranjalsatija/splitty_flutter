import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

import 'main_tab.dart';

enum SplitDetailScreenMode {
  readWrite, readOnly
}

class SplitDetailScreen extends StatelessWidget implements BottomNavigationBarScreen {
  final SplitDetailScreenMode mode;
  final VoidCallback pushHandler;
  final Stream<Split> splitStream;

  SplitDetailScreen({
    @required this.mode,
    @required this.pushHandler,
    @required this.splitStream,
  });

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
          mode: ItemScreenMode.newItem,
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

  Future<String> _promptUserForListTitle(BuildContext context) async {
    String textFieldContents;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.of(context).saveSplitPrompt),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Strings.of(context).saveSplitInstructions,
                style: Theme.of(context).textTheme.caption,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: Strings.of(context).splitName,
                ),
                onChanged: (value) => textFieldContents = value,
                onSubmitted: (_) => Navigator.pop(context, textFieldContents),
                textCapitalization: TextCapitalization.words,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, textFieldContents),
              child: Text(Strings.of(context).done),
            ),
          ],
        );
      },
    );
  }

  void _saveList(BuildContext context) async {
    final listTitle = await _promptUserForListTitle(context);
    if (listTitle != null && listTitle.isNotEmpty) {
      SplitController.saveCurrentSplit(listTitle);

      final snackbar = SnackBar(
        content: Text(Strings.of(context).savedSplit(listTitle)),
      );
      
      Scaffold.of(context).showSnackBar(snackbar);
    }
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

  Widget _buildBody(BuildContext context, Split split) {
    String title;

    switch (mode) {
      case SplitDetailScreenMode.readWrite:
        title = Strings.of(context).newSplit;
        break;
      case SplitDetailScreenMode.readOnly:
        title = split.name;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _buildSplitList(context, split),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    if (mode == SplitDetailScreenMode.readWrite) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addItem(context, null),
      );
    }

    return null;
  }

  Widget _buildSplitList(BuildContext context, Split split) {
    if (split.items.isEmpty) {
      return ListViewEmptyState(
        actionText: Strings.of(context).addItemPrompt,
        message: Strings.of(context).addItemMessage,
        onPressed: () => _addItem(context, null),
      );
    } else {
      return SplitList(
        deleteHandler: (item) => _deleteItem(context, item),
        saveHandler: () => _saveList(context),
        shouldAllowEditing: mode == SplitDetailScreenMode.readWrite,
        split: split,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Split>(
      stream: splitStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showErrorSnackbar(context, snapshot.error);
        }

        if (snapshot.hasData) {
          return _buildBody(context, snapshot.data);
        } else {
          pushHandler();
          return ExpandedLoadingIndicator();
        }
      },
    );
  }
}