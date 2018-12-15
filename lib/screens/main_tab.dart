import 'package:flutter/material.dart';

import 'existing_splits.dart';
import 'new_split.dart';
import 'people.dart';

abstract class BottomNavigationBarScreen extends Widget {
  BottomNavigationBarItem bottomNavigationBarItem(BuildContext context);
}

class MainTabScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTabScreenState();
  }
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;
  List<BottomNavigationBarScreen> _tabs = [
    NewSplitScreen(),
    ExistingSplitsScreen(),
    PeopleScreen(),
  ];

  void _updateSelectedIndex(int index) => setState(() {
    _selectedIndex = index;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _updateSelectedIndex,
        items: _tabs.map((s) => s.bottomNavigationBarItem(context)).toList(),
      ),
      body: _tabs[_selectedIndex],
      resizeToAvoidBottomPadding: false,
    );
  }
}