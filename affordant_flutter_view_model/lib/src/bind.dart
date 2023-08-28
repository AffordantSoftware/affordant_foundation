import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:affordant_view_model/affordant_view_model.dart';

class Bind<T> extends StatelessWidget {
  const Bind({
    required this.viewModel,
    required this.builder,
    super.key,
  });

  final ViewModel<T> viewModel;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: BlocBuilder<ViewModel<T>, T>(
        builder: builder,
      ),
    );
  }
}

class Bind2<T> extends StatelessWidget {
  const Bind2({
    required this.viewModel,
    required this.child,
    super.key,
  });

  final ViewModel<T> viewModel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => viewModel, child: child);
  }
}
