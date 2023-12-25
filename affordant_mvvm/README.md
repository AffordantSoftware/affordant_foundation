# Affordant MVVM
This package export common utilities and packages needed to implement MVVM architecture used at AffordantSoftware as described in this document [TODO: link]

This package advocate for a simple, flexible, performant and testable mvvm implementation while maintaining benefit of the mvvm architecture.

This package doesn't do much by itself. Instead, it is a curated selection of building blocs for the various aspect of [signals](), [provider]() and [get_it]() with some additional utilities.
A deep understanding of each of those package is primordial to implement mvvm correctly.

## Repository
Repositories are interface that let you retrieve and interact with the model layer of the application.
Repositories's data are exposed as `ReadonlySignal`s from the `signals` package. They also provides methods to interact with the repository and changes the underlying state.
Repositories should be accessed thought the dependency injection system. They are usually injected as singletons at the lunch of the app, but it's also possible to use factories for advanced scenarios.

## ViewModel
The default solution to implement ViewModel is a pure dart class exposing some ReadOnly signals and methods. The view model is bind to the view using a `Provider` and you can listen to each signal value in descendant widget by using `signal.watch`.
This package also export a `watchSignal` convenience method which is a shortcut for `context.watch<MyViewModel>().signal.watch(context)`.

This setup is straightforward and should be enough in most cases. However, in some rare case you may find useful to use something different reactive mechanisms than signals. In such cases, You can always bind your reactive class to the view using `Provider` but without relying on signals.

## Example
Define the repository:
```dart
class CounterRepository {
  final _count = signal(0);

  // Expose the signal as a read-only to prevent the outside world 
  // from editing the value
  ReadonlySignal<int> get count => _count;

  // changes the signal value internally
  void increment() {
    _count.value = _count.value + 1;
  }
}
```

Register the repository in th dependency injection system:
```dart
final di = GetIt.instance;

void main() {
  di.registerSingleton(CounterRepo());
  runApp(const MyApp());
}
```

Define the view-model:
```dart
import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'counter_repository.dart';

class CounterViewModel {
  CounterViewModel({
    // repository is provided using dependency injection
    required this.counterRepository,
  }) {
    // we compute the view model state using one or more repositories 
    // values
    counter = computed(() {
      return counterRepository.counter.value;
    });
  }

  final CounterRepo counterRepository;

  late final ReadonlySignal<int> counter;

  void increment() {
    // we call repository method that will re-trigger our computed signal
    counterRepository.increment();
  }
}
```

Bind the view-model to the view:
```dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CounterViewModel(
        // We access the repository from the dependency injection
        counterRepository: di.get(),
      ),
      child: ...
    );
  }
}
```

Consume view-model in the view:
```dart
class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // access provider's methods using context.watch
      onPressed: context.watch<CounterViewModel>().increment,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class _CounterValue extends StatelessWidget {
  const _CounterValue();

  @override
  Widget build(BuildContext context) {
    // watch provider's signals's values using context.watchSignal
    final value = context.watchSignal(
      (CounterViewModel vm) => vm.counter,
    );

    return Text(
      '$value',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
```