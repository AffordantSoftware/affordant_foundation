import 'dart:async';
import 'package:affordant_auth/affordant_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

typedef GoRouterRedirectDelegate = String? Function(
    BuildContext context, GoRouterState state);

typedef GetRouteDelegate = String Function(
    BuildContext context, GoRouterState state);

/// A refresh listenable for fo router
class _AuthChangeNotifier with ChangeNotifier {
  _AuthChangeNotifier(AuthRepository authRepository) {
    sub = authRepository.authStateChanges.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription sub;

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

final class _RouterAuthRedirectionDelegate {
  _RouterAuthRedirectionDelegate({
    required this.authRepository,
    required this.authenticationRouteDelegate,
    required this.defaultPrivateRouteDelegate,
    this.publicRoutes,
  });

  final AuthRepository authRepository;

  /// The list of public route
  /// Both auth and un-auth users can access those route
  /// A route is matched if the current location starts with the provided String,
  /// meaning all sub-routes will be matched too
  /// Do not include auth pages here since there are treated differently
  final List<String>? publicRoutes;

  /// The route the user will be redirected to for authentication
  final String Function(BuildContext context, GoRouterState state)
      authenticationRouteDelegate;

  /// The route the user will be redirected to after completed authentication
  final String Function(BuildContext context, GoRouterState state)
      defaultPrivateRouteDelegate;

  // String? lastPath;

  bool _matchPublicRoute(String path) {
    if (publicRoutes == null) return false;
    return publicRoutes?.firstWhereOrNull((e) => _matchRoute(path, e)) != null;
  }

  bool _matchRoute(String path, String route) {
    return path.startsWith(route) == true;
  }

  String? call(BuildContext context, GoRouterState state) {
    final path = state.fullPath;
    if (path == null) return null;
    final authenticationRoute = authenticationRouteDelegate(context, state);
    final isAuth = authRepository.currentUser != null;
    final matchAuthRoute = _matchRoute(path, authenticationRoute);
    final matchPublicRoute = _matchPublicRoute(path);
    final matchAuthOrPublicRoute = matchAuthRoute || matchPublicRoute;

    // if the user was previously on an private route, we save the route for
    // redirect him after the auth as been completed
    if (isAuth == false && matchAuthOrPublicRoute == false) {
      // lastPath = state.fullPath;
      return authenticationRoute;
    }
    // When authenticated redirect the user to the previously private page he
    // was on or the default private route
    // We call this redirection only when user is on auth page since auth user
    // can access public page too
    if (isAuth && matchAuthRoute) {
      return defaultPrivateRouteDelegate(context, state);
    }
    return null;
  }
}

extension AuthRepositoryGoRouterExtension on AuthRepository {
  /// Provides a refreshListenable for GoRouter that refresh every times auth status changes
  ChangeNotifier goRouterRefreshListenable() => _AuthChangeNotifier(this);

  /// Provides a redirect function for GoRouter that support guarding private routes
  /// (route that need user credential to be acceded) and
  /// redirecting to appropriate routes when user's auth status change.
  GoRouterRedirectDelegate goRouterAuthRedirect({
    /// Returns the route of the authentication page
    required GetRouteDelegate authenticationRouteDelegate,

    /// Returns the route the user will be redirected to when it's auth status changed
    required GetRouteDelegate defaultPrivateRouteDelegate,

    /// The list of routes available without being authenticated
    List<String>? publicRoutes,
  }) =>
      _RouterAuthRedirectionDelegate(
        authRepository: this,
        authenticationRouteDelegate: authenticationRouteDelegate,
        defaultPrivateRouteDelegate: defaultPrivateRouteDelegate,
        publicRoutes: publicRoutes,
      ).call;
}
