import 'package:flutter/material.dart';
import 'package:splitty/assets/strings/strings.dart';

import 'main_tab.dart';

class ExistingSplitsScreen extends StatelessWidget implements BottomNavigationBarScreen {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.list),
      title: Text(Strings.of(context).existingSplits),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).existingSplits),
      ),
    );
  }
}