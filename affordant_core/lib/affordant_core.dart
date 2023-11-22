import 'package:flutter/widgets.dart';

export 'package:get_it/get_it.dart' show Disposable;

mixin Displayable {
  String display(BuildContext context);
}

/// How to write a good error message:
/// Title: Say what happened
/// Message:
/// 1. Provides reassurance
/// 2. Say why its happened
/// 3. Help user fix issue
/// 4. Give a way out
///
/// Example:
/// Unable to save your changes
/// Your changes are saved locally, but we are unable to connect to your account because your device not connected to internet.
/// Please re-connect and try again. If the problem persist, contact [Customer Care](http://customercare.com)
abstract class DisplayableException {
  const DisplayableException(
    this.stackTrace,
  );

  final StackTrace stackTrace;

  String localizedTitle(BuildContext context);
  String localizedMessage(BuildContext context);
}
