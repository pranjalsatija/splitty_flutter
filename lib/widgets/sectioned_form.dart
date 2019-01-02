import 'package:flutter/material.dart';

class SectionedForm extends StatelessWidget {
  EdgeInsetsGeometry padding;
  List<FormSection> sections;

  SectionedForm({
    this.padding = const EdgeInsets.all(16),
    this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: sections,
        padding: padding,
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  final String title;
  final Widget body;

  FormSection({this.title, this.body});

  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class FormSectionBody extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  FormSectionBody({
    this.children,
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