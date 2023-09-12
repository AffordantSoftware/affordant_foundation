import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:affordant_auth/affordant_auth.dart';

typedef User = fb.User;

abstract class FirebaseUserService extends UserService<fb.User> {
  const FirebaseUserService(AuthService<fb.User> firebaseAuthService)
      : super(firebaseAuthService);
}

final class FirebaseAuthService extends AuthService<fb.User> {
  FirebaseAuthService({
    super.registerUserServices,
    super.disposeUserServices,
  });

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
