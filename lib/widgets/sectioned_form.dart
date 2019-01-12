import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final Widget body;
  final EdgeInsetsGeometry padding;
  final String title;

  FormSection({
    @required this.body,
    this.padding = const EdgeInsets.only(top: 16, left: 16, right: 16),
    @required this.title,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
            style: Theme.of(context).textTheme.headline,
          ),
          Container(height: 4),
          Container(
            child: body,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormSectionBody extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  FormSectionBody({
    @required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    final padded = (Widget widget) => Padding(
      child: widget,
      padding: padding,
    );

    List<Widget> children = List();
    this.children.take(this.children.length - 1).forEach((child) {
      children.add(padded(child));
      children.add(Divider(height: 1));
    });

    children.add(padded(this.children.last));

    return Column(
      children: children,
    );
  }
}