import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

mixin Displayable {
  String display(BuildContext context);
}

mixin DependencyInjection {
  GetIt get di => GetIt.I;
}
