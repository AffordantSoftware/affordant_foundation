import 'package:flutter/widgets.dart';

export 'package:get_it/get_it.dart' show Disposable;

mixin Displayable {
  String display(BuildContext context);
}

base class DisplayableError with Displayable {
  DisplayableError(this.error, this.stackTrace);

  final dynamic error;
  final StackTrace stackTrace;

  @override
  String display(BuildContext context) {
    return "error toString";
  }
}
