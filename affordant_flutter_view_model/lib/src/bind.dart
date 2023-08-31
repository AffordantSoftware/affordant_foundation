import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:affordant_view_model/affordant_view_model.dart';

class Bind<T extends ViewModel> extends StatelessWidget {
  const Bind({
    required this.viewModel,
    required this.child,
    super.key,
  });

  static BindAndConsume consume<T extends ViewModel<S>, S>({
    required T viewModel,
    required final Widget Function(BuildContext context, S state) builder,
    Key? key,
  }) =>
      BindAndConsume<T, S>(
        viewModel: viewModel,
        builder: builder,
        key: key,
      );

  final T viewModel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (context) => viewModel,
      child: child,
    );
  }
}

class BindAndConsume<T extends ViewModel<S>, S> extends StatelessWidget {
  const BindAndConsume({
    required this.viewModel,
    required this.builder,
    super.key,
  });

  final T viewModel;
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (context) => viewModel,
      child: BlocBuilder(
        bloc: viewModel,
        builder: builder,
      ),
    );
  }
}
