import 'package:affordant_core/affordant_core.dart';

import 'navigation_service.dart';

base mixin Navigation on DependencyInjection {
  NavigationService get navigation => di.get<NavigationService>();
}
