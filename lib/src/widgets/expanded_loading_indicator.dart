import 'package:flutter/material.dart';

typedef LoadingIndicatorBuilder = Widget Function(BuildContext context);

class ExpandedLoadingIndicator extends StatelessWidget {
  final LoadingIndicatorBuilder builder;

  ExpandedLoadingIndicator({
    this.builder
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = CircularProgressIndicator();
    if (builder != null) {
      loadingIndicator = builder(context);
    }

    return Container(
      alignment: Alignment.center,
      child: loadingIndicator,
    );
  }
}