import 'package:flutter/material.dart';
import 'package:splitty/splitty.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MainTabScreen(),
    );
  }
}