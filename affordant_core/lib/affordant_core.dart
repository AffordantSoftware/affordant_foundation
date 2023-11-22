import 'package:flutter/widgets.dart';

export 'package:get_it/get_it.dart' show Disposable;

mixin Displayable {
  String display(BuildContext context);
}

abstract class DisplayableException with Displayable {
  const DisplayableException(this.stackTrace);

  final StackTrace stackTrace;
}
