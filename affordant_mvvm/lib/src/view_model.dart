import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

abstract class ViewModel<State extends Object> {
  ViewModel(State initial) : _state = signal(initial);

  final Signal<State> _state;
  State get state => _state.value;
  bool mounted = true;

  @protected
  void emit(State state) {
    _state.value = state;
  }

  @mustCallSuper
  void dispose() {
    mounted = false;
    _state.dispose();
  }
}

mixin EffectMixin<T extends Object> on ViewModel<T> {
  late final List<Function()> _disposers = [];

  void useEffect(Function() effect) {
    _disposers.add(effect);
  }

  @override
  void dispose() {
    for (final d in _disposers) {
      d.call();
    }
    super.dispose();
  }
}

/// {@template bloc_provider}
/// Takes a [Create] function that is responsible for
/// creating the [Bloc] or [Cubit] and a [child] which will have access
/// to the instance via `BlocProvider.of(context)`.
/// It is used as a dependency injection (DI) widget so that a single instance
/// of a [Bloc] or [Cubit] can be provided to multiple widgets within a subtree.
///
/// ```dart
/// BlocProvider(
///   create: (BuildContext context) => BlocA(),
///   child: ChildA(),
/// );
/// ```
///
/// It automatically handles closing the instance when used with [Create].
/// By default, [Create] is called only when the instance is accessed.
/// To override this behavior, set [lazy] to `false`.
///
/// ```dart
/// BlocProvider(
///   lazy: false,
///   create: (BuildContext context) => BlocA(),
///   child: ChildA(),
/// );
/// ```
///
/// {@endtemplate}
class ViewModelProvider<T extends ViewModel>
    extends SingleChildStatelessWidget {
  /// {@macro bloc_provider}
  const ViewModelProvider({
    required Create<T> create,
    Key? key,
    this.child,
    this.lazy = true,
  })  : _create = create,
        _value = null,
        super(key: key, child: child);

  /// Takes a [value] and a [child] which will have access to the [value] via
  /// `BlocProvider.of(context)`.
  /// When `BlocProvider.value` is used, the [Bloc] or [Cubit]
  /// will not be automatically closed.
  /// As a result, `BlocProvider.value` should only be used for providing
  /// existing instances to new subtrees.
  ///
  /// A new [Bloc] or [Cubit] should not be created in `BlocProvider.value`.
  /// New instances should always be created using the
  /// default constructor within the [Create] function.
  ///
  /// ```dart
  /// BlocProvider.value(
  ///   value: BlocProvider.of<BlocA>(context),
  ///   child: ScreenA(),
  /// );
  /// ```
  const ViewModelProvider.value({
    required T value,
    Key? key,
    this.child,
  })  : _value = value,
        _create = null,
        lazy = true,
        super(key: key, child: child);

  /// Widget which will have access to the [Bloc] or [Cubit].
  final Widget? child;

  /// Whether the [Bloc] or [Cubit] should be created lazily.
  /// Defaults to `true`.
  final bool lazy;

  final Create<T>? _create;

  final T? _value;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '$runtimeType used outside of MultiBlocProvider must specify a child',
    );
    final value = _value;
    return value != null
        ? InheritedProvider<T>.value(
            value: value,
            startListening: _startListening,
            lazy: lazy,
            child: child,
          )
        : InheritedProvider<T>(
            create: _create,
            dispose: (_, vm) => vm.dispose(),
            startListening: _startListening,
            lazy: lazy,
            child: child,
          );
  }

  static VoidCallback _startListening(
    InheritedContext<ViewModel<dynamic>?> e,
    ViewModel<dynamic> value,
  ) {
    // final subscription = value.stream.listen(
    //   (dynamic _) => e.markNeedsNotifyDependents(),
    // );
    // return subscription.cancel;
    return () {};
  }
}
