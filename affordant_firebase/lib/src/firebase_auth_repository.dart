import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:affordant_auth/affordant_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef User = fb.User;

Future<T> _safeFirebaseCall<T>(
  Future<T> Function() run,
  Object? Function(fb.FirebaseAuthException e, String code) errorConverter,
) async {
  try {
    return await run();
  } on fb.FirebaseAuthException catch (e) {
    final converted = errorConverter(e, e.code);
    if (converted != null) {
      throw converted;
    } else {
      rethrow;
    }
  }
}

Object? _convertSignInWithEmailAndPAsswordErrorCodeToException(
        Object e, String code) =>
    switch (code) {
      'invalid-email' ||
      'invalid-credential' ||
      'rejected-credential' ||
      'INVALID_LOGIN_CREDENTIALS' =>
        InvalidCredentialException(),
      _ => null,
    };

final class FirebaseAuthRepository extends AuthRepository<fb.User> {
  FirebaseAuthRepository({
    super.registerPrivateRepositories,
    super.disposePrivateRepositories,
    required String? googleIOSClientID,
  }) : _googleSignIn = GoogleSignIn(
            scopes: ['email'],
            hostedDomain: "",
            clientId: Platform.isIOS ? googleIOSClientID : null);

  final GoogleSignIn _googleSignIn;

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
    return await _safeFirebaseCall(
      () => _safeSignInCall(
        () => _firebase.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ),
      _convertSignInWithEmailAndPAsswordErrorCodeToException,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    return await _safeFirebaseCall(
      () => _safeSignInCall(
        () async {
          try {
            final GoogleSignInAccount? googleUser =
                await _googleSignIn.signIn();

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
          } catch (e) {
            await _firebase.signOut();
            rethrow;
          }
        },
      ),
      (e, _) => SocialSignInException(e),
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _safeFirebaseCall(
      () => _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
      (e, code) => switch (code) {
        'email-already-in-use' => AccountAlreadyExistsException(),
        'email-already-exists' => AccountAlreadyExistsException(),
        _ => null,
      },
    );
  }

  @override
  Future<void> signOut() async {
    try {
      switch (currentProvider) {
        case AuthProvider.google:
          await _googleSignIn.disconnect();
        default:
      }
    } finally {
      await _firebase.signOut();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebase.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> deleteAccount() async {
    final provider = currentProvider;
    await _firebase.currentUser?.delete();

    switch (provider) {
      case AuthProvider.google:
        await _googleSignIn.disconnect();
      default:
    }
  }

  @override
  Future<void> signInWithApple() async {
    return await _safeFirebaseCall(
      () => _safeSignInCall(
        () async {
          final appleProvider = fb.AppleAuthProvider();
          if (kIsWeb) {
            await _firebase.signInWithPopup(appleProvider);
          } else {
            await _firebase.signInWithProvider(appleProvider);
          }
          return;
        },
      ),
      (e, code) => SocialSignInException(e),
    );
  }

  @override
  Future<void> signInWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _safeFirebaseCall(
      () => _safeSignInCall(
          () => _firebase.currentUser!.reauthenticateWithCredential(
                fb.EmailAuthProvider.credential(
                  email: email,
                  password: password,
                ),
              )),
      _convertSignInWithEmailAndPAsswordErrorCodeToException,
    );
  }

  @override
  Future<void> reauthenticateWithSocialProvider() async {
    final user = _firebase.currentUser!;
    Object? error;

    for (final fb.UserInfo(:providerId) in user.providerData.reversed) {
      try {
        switch (providerId) {
          case 'google.com':
            return await _reauthenticateWithGoogle(user);
          case 'apple.com':
            return await _reauthenticateWithApple(user);
          //  'facebook.com' =>
          //  'password' =>
          default:
        }
      } catch (e) {
        error = e;
        continue;
      }
    }
    throw error ?? Error();
  }

  @override
  AuthProvider? get currentProvider {
    for (final fb.UserInfo(:providerId)
        in _firebase.currentUser?.providerData.reversed ?? []) {
      final provider = switch (providerId) {
        'google.com' => AuthProvider.google,
        'apple.com' => AuthProvider.apple,
        'password' => AuthProvider.emailAndPassword,
        'facebook.com' => AuthProvider.facebook,
        'twitter.com' => AuthProvider.twitter,
        'microsoft.com' => AuthProvider.microsoft,
        'github.com' => AuthProvider.github,
        'yahoo.com' => AuthProvider.yahoo,
        _ => null,
      };
      if (provider != null) return provider;
    }
    throw Error();
  }

  Future<void> _reauthenticateWithGoogle(fb.User user) async {
    return await _safeFirebaseCall(
      () async {
        final googleUser = await _googleSignIn
            .signInSilently(reAuthenticate: true)
            .catchError((error, stackTrace) => _googleSignIn.signIn());

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = fb.GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        await user.reauthenticateWithCredential(credential);
      },
      (e, _) => SocialSignInException(e),
    );
  }

  Future<void> _reauthenticateWithApple(fb.User user) async {
    return await _safeFirebaseCall(
      () async {
        final appleProvider = fb.AppleAuthProvider();
        await user.reauthenticateWithProvider(appleProvider);
      },
      (e, _) => SocialSignInException(e),
    );
  }

  @override
  Future<void> reauthenticate({
    required Future<EmailAndPassword> Function() getEmailAndPassword,
  }) async {
    switch (currentProvider) {
      case null:
        throw Error();
      case AuthProvider.emailAndPassword:
        final credentials = await getEmailAndPassword();
        return await reauthenticateWithEmailAndPassword(
          email: credentials.email,
          password: credentials.password,
        );
      default:
        return await reauthenticateWithSocialProvider();
    }
  }

  Future<T> _safeSignInCall<T>(
    Future<T> Function() run,
  ) async {
    try {
      return await run();
    } catch (e) {
      signOut().ignore();
      rethrow;
    }
  }
}
