import 'package:flutter/widgets.dart';

export 'package:get_it/get_it.dart' show Disposable;

mixin Displayable {
  String display(BuildContext context);
}

abstract base class DisplayableError with Displayable {
  const DisplayableError(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
