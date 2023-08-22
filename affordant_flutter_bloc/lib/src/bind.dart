import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:affordant_bloc/affordant_bloc.dart';

mixin Consumer on StatelessWidget {
  void run() {}
}

mixin ConsumerState on State {
  void run({
    Function? onError,
  }) {}

  Widget watch<T>(
    Query<T> query,
    Widget Function(BuildContext context, T value) builder,
  );
}

extension BindQuery<T> on Query<T> {
  Widget bind(Widget Function(BuildContext context, T value) builder) =>
      Bind(query: this, builder: builder);
}

class Bind<T> extends StatelessWidget {
  const Bind({
    required this.query,
    required this.builder,
    super.key,
  });

  final Query<T> query;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => query,
      child: BlocBuilder<Query<T>, T>(
        builder: builder,
      ),
    );
  }
}
