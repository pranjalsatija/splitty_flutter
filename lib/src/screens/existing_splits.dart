import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

class ExistingSplitsScreen extends StatelessWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.list),
      title: Text(Strings.of(context).existingSplits),
    );
  }

  Widget _buildBody(BuildContext context, List<Split> splits) {
    return ListView.separated(
      itemCount: splits.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(splits[index].name),
          subtitle: Text(splits[index].formattedDate),
          onTap: null,
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