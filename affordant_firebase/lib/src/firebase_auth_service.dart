import 'dart:async';
import 'dart:io';
import 'package:affordant_core/affordant_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:affordant_auth/affordant_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef User = fb.User;

// Future<Result<T, E>> _safeFirebaseCall<T, E extends Error>(
//   Future<T> Function() run,
//   Map<String, E Function(Error e)>? onErrorCode,
//   E Function(Error e) onUnknownError,
// ) async {
//   return await safeNetworkCall(
//     run,
//   ).mapErr(
//     (e) {
//       e.withContext("call FirebaseAuth");
//       E? convertedError;
//       if (e case Err(error: final fb.FirebaseAuthException firebaseError)) {
//         convertedError = onErrorCode?[firebaseError.code]?.call(e);
//       }
//       return convertedError ?? onUnknownError(e);
//     },
//   );
// }

Future<Result<T, E>> _safeFirebaseCall<T, E extends Error>(
  Future<T> Function() run,
  E Function(Error e, String? code) onError,
) async {
  return await safeNetworkCall(
    run,
  ).mapErr(
    (e) {
      e.withContext("call FirebaseAuth");
      return switch (e) {
        fb.FirebaseAuthException firebaseError =>
          onError(e, firebaseError.code),
        _ => onError(e, null),
      };
    },
  );
}

final class FirebaseAuthRepository extends AuthRepository<fb.User> {
  FirebaseAuthRepository({
    super.registerPrivateRepositories,
    super.disposePrivateRepositories,
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
  Future<Result<void, SignInError>> signInAnonymously() async {
    return await _safeFirebaseCall(
      _firebase.signInAnonymously,
      (error, code) =>
          AnonymousSignInError(error)..withContext("Sign-in anonymously"),
    );
  }

  @override
  Future<Result<void, SignInError>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _safeFirebaseCall(
      () => _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
      (e, code) {
        e.withContext("Sign-in with email and password");
        return switch (code) {
          'invalid-email' ||
          'invalid-credential' ||
          'rejected-credential' =>
            InvalidCredentialError(e),
          _ => UnknownSignInError(e),
        };
      },
    );
  }

  @override
  Future<Result<void, SignInError>> signInWithGoogle({
    required String iosClientID,
  }) async {
    return await _safeFirebaseCall(
      () async {
        String? clientID;
        if (Platform.isIOS) {
          clientID = iosClientID;
        }

        final signIn = GoogleSignIn(
          scopes: ['email'],
          hostedDomain: "",
          clientId: clientID,
        );
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
        await _firebase.signInWithCredential(credential);
      },
      (e, _) => GoogleSignInError(e),
    );
  }

  @override
  Future<Result<void, RegistrationError>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _safeFirebaseCall(
      () => _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
      (e, code) => switch (code) {
        'email-already-exists' => AccountAlreadyExistsError(e),
        _ => UnknownRegistrationError(e),
      }
        ..withContext("Create user with email and password"),
    );
  }

  @override
  CommandResult<SignOutError> signOut() async {
    try {
      await _firebase.signOut();
      await GoogleSignIn().disconnect();
      return ok();
    } catch (e, s) {
      return Err(SignOutError(e, s));
    }
  }

  @override
  CommandResult<ResetPasswordError> sendPasswordResetEmail(String email) async {
    return await _safeFirebaseCall(
      () => _firebase.sendPasswordResetEmail(email: email),
      (e, _) => ResetPasswordError(e),
    );
  }

  @override
  CommandResult<DeleteAccountError> deleteAccount() async {
    return await _safeFirebaseCall(
      () async {
        await _firebase.currentUser?.delete();
      },
      (e, code) => DeleteAccountError(e),
    );
  }

  @override
  CommandResult<SignInError> signInWithApple() async {
    return await _safeFirebaseCall(
      () async {
        final appleProvider = fb.AppleAuthProvider();
        if (kIsWeb) {
          await _firebase.signInWithPopup(appleProvider);
        } else {
          await _firebase.signInWithProvider(appleProvider);
        }
      },
      (e, code) => AppleSignInError(e),
    );
  }

  @override
  CommandResult<SignInError> signInWithFacebook() {
    throw UnimplementedError();
  }

  @override
  CommandResult<ReAuthenticateError> reAuthenticate() {
    throw UnimplementedError();
  }
}
