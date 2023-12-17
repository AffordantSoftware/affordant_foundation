import 'dart:async';
import 'package:affordant_auth/affordant_auth.dart';
import 'package:affordant_core/affordant_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

part 'exceptions.dart';

const _authScopeName = "authScope";

typedef RegisterPrivateRepository<User> = FutureOr<void> Function(
  GetIt,
  AuthRepository<User>,
);
typedef DisposePrivateRepositoryDelegate = FutureOr<void> Function();
typedef EmailAndPassword = ({String email, String password});

enum AuthProvider {
  emailAndPassword,
  google,
  apple,
  facebook,
  microsoft,
  twitter,
  github,
  yahoo,
}

/// Repository that manage user authentication
///
/// [registerPrivateRepositories] is used to instantiate user's private repositories when he successfully signed-in
/// [disposePrivateRepositories] gives the opportunity do dispose private repositories ressources when user sign-out
abstract base class AuthRepository<AuthData> with Disposable {
  AuthRepository({
    this.registerPrivateRepositories,
    this.disposePrivateRepositories,
  }) {
    _authChangesSub = authStateChanges.listen((user) {
      if (user != null) {
        pushAuthScope(user);
      } else {
        dropAuthScope();
      }
    });
  }

  late final StreamSubscription<AuthData?> _authChangesSub;

  final FutureOr<void> Function(
    GetIt,
    AuthRepository<AuthData>,
  )? registerPrivateRepositories;

  final DisposePrivateRepositoryDelegate? disposePrivateRepositories;

  Stream<AuthData?> get authStateChanges;

  Stream<AuthData?> get idTokenChanges;

  Stream<AuthData?> get userChangeStream;

  AuthData? get currentUser;

  AuthProvider? get currentProvider;

  @override
  Future<void> onDispose() async {
    await _authChangesSub.cancel();
  }

  @protected
  void pushAuthScope(AuthData user) {
    final delegate = registerPrivateRepositories;
    if (delegate != null) {
      GetIt.instance.pushNewScopeAsync(
        scopeName: _authScopeName,
        init: (scope) async => await delegate(scope, this),
        dispose: disposePrivateRepositories,
      );
    }
  }

  @protected
  void dropAuthScope() {
    if (registerPrivateRepositories != null &&
        GetIt.instance.hasScope(_authScopeName)) {
      GetIt.instance.dropScope(_authScopeName);
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInAnonymously();

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  Future<void> signInWithFacebook();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> reauthenticate({
    required Future<EmailAndPassword> Function() getEmailAndPassword,
  });

  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> reauthenticateWithSocialProvider();

  Future<void> deleteAccount();
}
