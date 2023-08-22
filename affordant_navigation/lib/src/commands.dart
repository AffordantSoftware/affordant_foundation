import 'package:affordant_bloc/affordant_bloc.dart';

import 'package:get_it/get_it.dart';

import 'navigation_service.dart';

base mixin Navigation on DependencyInjection {
  NavigationService get navigation => GetIt.I.get();
}

final class NavigateTo extends Command with Navigation {
  NavigateTo(this.location);

  final String location;

  @override
  void run() {
    navigation.go(location);
  }
}
