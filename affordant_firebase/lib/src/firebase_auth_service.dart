import 'dart:async';
import 'dart:io';
import 'package:affordant_core/affordant_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:affordant_auth/affordant_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef User = fb.User;

FutureOr<T> _safeFirebaseCall<T>(
  FutureOr<T> Function() run, [
  Map<String, Function(Object e, StackTrace s)>? convertExceptions,
]) async {
  return await safeServerCall(() async {
    try {
      return await run();
    } on fb.FirebaseAuthException catch (e, s) {
      final converter = convertExceptions?[e.code];
      if (converter != null) {
        throw converter(e, s);
      } else {
        rethrow;
      }
    }
  });
}

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

  GoogleSignIn? _googleSignIn;

  @override
  Future<void> signInAnonymously() async {
    await _safeFirebaseCall(_firebase.signInAnonymously);
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _safeFirebaseCall(
      () => _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
      {
        'invalid-email': (e, s) => InvalidCredentialException(),
        'invalid-credential': (e, s) => InvalidCredentialException(),
        'rejected-credential': (e, s) => InvalidCredentialException(),
      },
    );
  }

  @override
  Future<void> signInWithGoogle({
    required String iosClientID,
  }) async {
    await _safeFirebaseCall(() async {
      String? clientID;
      if (Platform.isIOS) {
        clientID = iosClientID;
      }

      final signIn = GoogleSignIn(
        scopes: ['email'],
        hostedDomain: "",
        clientId: clientID,
      );
      _googleSignIn = signIn;
      final GoogleSignInAccount? googleUser = await signIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _firebase.signInWithCredential(credential);
    });
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _safeFirebaseCall(
      () => _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
      {
        'email-already-exists': (e, s) => AccountAlreadyExistsException(),
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _safeFirebaseCall(_firebase.signOut);
    await _googleSignIn?.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _safeFirebaseCall(
      () => _firebase.sendPasswordResetEmail(email: email),
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _firebase.currentUser?.delete();
  }
}
