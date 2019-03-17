import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

class ExistingSplitsScreen extends StatelessWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.list),
      title: Text(Strings.of(context).existingSplits),
    );
  }

  void _presentSplitDetail(BuildContext context, Split split) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => SplitDetailScreen(
          mode: SplitDetailScreenMode.readOnly,
          pushHandler: () {},
          splitStream: SingleValueStream(split).backingStream,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Split> splits) {
    if (splits == null || splits.isEmpty) {
      return ListViewEmptyState(
        message: Strings.of(context).noSplits,
      );
    }

    return ListView.separated(
      itemCount: splits.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(splits[index].name),
          subtitle: Text(splits[index].formattedDate),
          onTap: () => _presentSplitDetail(context, splits[index]),
        );
      },
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).existingSplits),
      ),
      body: StreamBuilder<List<Split>>(
        stream: SplitController.allSplitsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrorSnackbar(context, snapshot.error);
          }

          if (snapshot.hasData) {
            return _buildBody(context, snapshot.data);
          } else {
            SplitController.pushAllSplits();
            return ExpandedLoadingIndicator();
          }
        },
      ),
    );
  }
}