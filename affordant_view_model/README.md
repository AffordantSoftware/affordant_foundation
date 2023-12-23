# Affordant View Model
This package export common utilities needed to create view-models in Affordant Application

## Defining ViewModel
The default solution to implement ViewModel are StateNotifier from the state_notifier package which this package re-export. We are referring them as StateFull View Models. However, in some case you may find useful to use something different mechanism to support your view model such as ChangeNotifier, ValueNotifier or any other reactive object.

## Binding ViewModel to the View:
We are using the provider package to bind ViewModel to the View.
Depending of the type of your ViewModel you will need to use a specialized provider type such as `StateNotifierProvider`, `ChangeNotifierProvider`, etc.

## Additional utilities

**`Listener`**
A mixin for StateNotifier that let you subscribe to a stream and perform side effects / emit new state each time an event is received, thank to `onEach` and `forEach`and `forEachAsync`.

**`ReassignableStreamSubscription`**
A Special StreamSubscription for `Listener`s which its stream source can be re-assigned.