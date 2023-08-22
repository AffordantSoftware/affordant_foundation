import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:affordant_bloc/affordant_bloc.dart';

class Bind<T> extends StatelessWidget {
  const Bind({
    required this.query,
    required this.builder,
    super.key,
  });

  final ViewModel<T> query;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => query,
      child: BlocBuilder<ViewModel<T>, T>(
        builder: builder,
      ),
    );
  }
}

class Bind2<T> extends StatelessWidget {
  const Bind2({
    required this.query,
    required this.child,
    super.key,
  });

  final ViewModel<T> query;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => query, child: child);
  }
}
