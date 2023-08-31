import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:affordant_view_model/affordant_view_model.dart';

class Bind<T extends ViewModel> extends StatelessWidget {
  const Bind({
    required this.create,
    required this.child,
    super.key,
  });

  static BindAndConsume consume<T extends ViewModel<S>, S>({
    required T Function(BuildContext) create,
    required final Widget Function(BuildContext context, S state) builder,
    Key? key,
  }) =>
      BindAndConsume<T, S>(
        create: create,
        builder: builder,
        key: key,
      );

  final T Function(BuildContext) create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: create,
      child: child,
    );
  }
}

class BindAndConsume<T extends ViewModel<S>, S> extends StatelessWidget {
  const BindAndConsume({
    required this.create,
    required this.builder,
    super.key,
  });

  final T Function(BuildContext) create;
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: create,
      child: Builder(
        builder: (context) => BlocBuilder<T, S>(
          bloc: context.read(),
          builder: builder,
        ),
      ),
    );
  }
}
