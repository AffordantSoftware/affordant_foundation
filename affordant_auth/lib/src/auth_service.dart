import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

typedef RegisterUserServicesDelegate<User> = FutureOr<void> Function(
  GetIt,
  AuthService<User>,
);
typedef DisposeUserServicesDelegate = FutureOr<void> Function();

const _authScopeName = "authScope";

abstract base class AuthService<User> with Disposable {
  AuthService({
    this.registerUserServices,
    this.disposeUserServices,
  }) {
    _authChangesSub = authStateChanges.listen((user) {
      if (user != null) {
        pushAuthScope(user);
      } else {
        dropAuthScope();
      }
    });
  }

  late final StreamSubscription<User?> _authChangesSub;

  final FutureOr<void> Function(
    GetIt,
    AuthService<User>,
  )? registerUserServices;

  final DisposeUserServicesDelegate? disposeUserServices;

  Stream<User?> get authStateChanges;

  Stream<User?> get idTokenChanges;

  Stream<User?> get userChangeStream;

  User? get currentUser;

  @override
  Future<void> onDispose() async {
    await _authChangesSub.cancel();
  }

  @protected
  void pushAuthScope(User user) {
    final delegate = registerUserServices;
    if (delegate != null) {
      GetIt.instance.pushNewScopeAsync(
        scopeName: _authScopeName,
        init: (scope) async => await delegate(scope, this),
        dispose: disposeUserServices,
      );
    }
  }

  @protected
  void dropAuthScope() {
    if (registerUserServices != null &&
        GetIt.instance.hasScope(_authScopeName)) {
      GetIt.instance.dropScope(_authScopeName);
    }
  }

  /// throw `InvalidCredentialException` on unrecognized credentials
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// throw `AccountAlreadyExistsException` if account already exists
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInAnonymously();

  Future<void> signInWithGoogle({
    required String iosClientID,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> deleteAccount();
}
