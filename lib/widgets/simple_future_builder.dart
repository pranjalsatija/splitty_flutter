import 'package:flutter/material.dart';

typedef CacheSaver<T> = void Function(T data);
typedef FinishedWidgetBuilder<T> = Widget Function(BuildContext context, T result, Object error);
typedef LoadingWidgetBuilder = Widget Function(BuildContext context);

/// This widget works similarly to [FutureBuilder], but with a simplified API
/// and support for caching to ensure that the user doesn't see loading states
/// too frequently. It also simplifies the concept of [AsyncSnapshot] so [Future]
/// results can be expressed as either loading or finished.
@immutable
class SimpleFutureBuilder<T> extends StatelessWidget {
  /// The cached data to make available to this widget. If [future] is loading
  /// and [cachedData] is non-null, it will be used to create a finished state.
  final T cachedData;

  /// The Future to wait on.
  final Future<T> future;

  /// The function responsible for saving cached data once it's made available.
  /// [cacheSaver] should store the data in a way that it can be passed back to
  /// this widget through [cachedData].
  final CacheSaver<T> cacheSaver;

  /// The builder responsible for creating a loading state to be displayed.
  final LoadingWidgetBuilder loadingWidgetBuilder;

  /// The builder responsible for creating a finished state to be displayed.
  final FinishedWidgetBuilder<T> finishedWidgetBuilder;

  SimpleFutureBuilder({@required this.future, this.cachedData, this.cacheSaver, @required this.loadingWidgetBuilder, @required this.finishedWidgetBuilder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            if (cachedData == null) {
              return loadingWidgetBuilder(context);
            }

            continue hasData;

          hasData:
          default:
            if (snapshot.hasData && cacheSaver != null) {
              cacheSaver(snapshot.data);
            }

            return finishedWidgetBuilder(context, snapshot.data ?? cachedData, snapshot.error);
        }
      },
      initialData: cacheSaver,
    );
  }
}