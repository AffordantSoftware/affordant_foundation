import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_model.dart';

class Bind<T extends ViewModel> extends StatelessWidget {
  const Bind({
    required this.create,
    this.child,
    super.key,
  });

  final T Function(BuildContext) create;
  final Widget? child;

  /// This function is used by th BindMany widget to workaround type issue
  /// with MultiBlocProvider
  BlocProvider<T> _toBlocProvider() => BlocProvider<T>(
        create: create,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return _toBlocProvider();
  }
}

class BindMany<T extends ViewModel> extends StatelessWidget {
  const BindMany({
    required this.bind,
    required this.child,
    super.key,
  });

  final List<Bind> bind;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: bind.map((bind) => bind._toBlocProvider()).toList(),
      child: child,
    );
  }
}
