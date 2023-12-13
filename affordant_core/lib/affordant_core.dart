import 'package:flutter/widgets.dart';

export 'src/l10n/affordant_core_localizations.dart';
export 'src/exceptions.dart';
export 'src/utils.dart';

mixin Displayable {
  String display(BuildContext context);
}
