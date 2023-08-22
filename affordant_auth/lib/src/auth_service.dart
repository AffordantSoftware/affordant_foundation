import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

typedef RegisterUserServicesDelegate = FutureOr<void> Function(GetIt, User);
typedef DisposeUserServicesDelegate = FutureOr<void> Function();

typedef User = fb.User;

const _authScopeName = "authScope";

abstract base class AuthService with Disposable {
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
  final RegisterUserServicesDelegate? registerUserServices;
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
        init: (scope) async => await delegate(scope, user),
        dispose: disposeUserServices,
      );
    }
  }

  @protected
  void dropAuthScope() {
    if (registerUserServices != null) {
      GetIt.instance.dropScope(_authScopeName);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInAnonymously();

  Future<void> signOut();
}

final class FirebaseAuthService extends AuthService {
  FirebaseAuthService({super.registerUserServices});

  fb.FirebaseAuth get _firebase => fb.FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges => _firebase.authStateChanges();

  @override
  Stream<User?> get idTokenChanges => _firebase.idTokenChanges();

  @override
  Stream<User?> get userChangeStream => _firebase.userChanges();

  @override
  User? get currentUser => _firebase.currentUser;

  @override
  Future<void> signInAnonymously() async {
    await _firebase.signInAnonymously();
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebase.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebase.signOut();
  }
}
