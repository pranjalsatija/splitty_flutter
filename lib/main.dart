import 'package:flutter/material.dart';

import './assets/strings/strings.dart';
import './screens/main_tab.dart';

void main() => runApp(Splitty());

class Splitty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        StringsLocalizationDelegate(),
      ],
      onGenerateTitle: (context) => Strings.of(context).appName,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainTabScreen(),
    );
  }
}