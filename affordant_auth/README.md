## Usage

Add AffordantAuthLocalizations.delegate to your localization delegate list:

```dart
MaterialApp(
    localizationDelegates: [
        AffordantAuthLocalizations.delegate
    ],
    ...
)
```

## GoRouter integration
Auth repository also provides a redirect callback and a refresh listenable for GoRouter.

The refreshListenable trigger a router refresh each times auth status changes.
The redirect function let's you define public, private and authentication routes and should be used as top level redirect function.


```dart
final router = GoRouter(
  observers: [routeObserver],
  initialLocation: const AuthRoute().location,
  redirect: Services.auth.goRouterAuthRedirect(
    authenticationRouteDelegate: (_, __) => const AuthRoute().location,
    defaultPrivateRouteDelegate: (_, __) => HomeRoute().location,
    publicRoutes: [
      TermsRoute().location,
      PrivacyRoute().location,
      AboutRoute().location,
    ],
  ),
  refreshListenable: Services.auth.goRouterRefreshListenable(),
  routes: $appRoutes,
);
```