# Affordant Core

## Installation
Add AffordantCoreLocalizations.delegate to your MaterialApp

```dart
 MaterialApp.router(
  routerConfig: router,
  theme: lightTheme,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AffordantCoreLocalizations.delegate,
  ],
);
```

## Utils

### Debouncer 
An object used to debounce a repetitive function calls.

```dart
final debouncer = Debouncer.duration(const Duration(milliseconds: 220));

for (final i = 0; i < 100; i++) {
  debouncer.debounce(() {
  // api call
  });
}

// dispose the debouncer once no more needed
debouncer.dispose();
```
