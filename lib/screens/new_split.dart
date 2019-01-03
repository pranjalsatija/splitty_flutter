import 'package:flutter/material.dart';
import 'package:splitty/assets/strings.dart';
import 'package:splitty/models/_index.dart';
import 'package:splitty/screens/new_item/new_item.dart';
import 'package:splitty/widgets/_index.dart';

import 'main_tab.dart';

class NewSplitScreen extends StatefulWidget
    implements BottomNavigationBarScreen {
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

  _NewSplitScreenState() {
    _currentSplitFuture = SplitController.currentSplit();
  }

  void _addItem() async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NewItemScreen()),
    );
  }

  Widget _buildItemListTile(Item item) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(item.formattedDescription),
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
              onPressed: () => _addItem(),
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
        onPressed: () => _addItem(),
      ),
    );
  }
}
