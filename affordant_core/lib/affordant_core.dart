import 'package:flutter/widgets.dart';

export 'src/l10n/affordant_core_localizations.dart';
export 'src/utils/network_call.dart';
export 'src/utils/utils.dart';
export 'src/nullable_extension.dart';
export 'src/result.dart';
export 'src/error.dart';
export 'src/repository.dart';

@Deprecated("Use specialized class instead. eg. [DisplayableError]")
mixin Displayable {
  String display(BuildContext context);
}
