import 'dart:async';

import 'package:affordant_auth/src/auth_service.dart';
import 'package:affordant_bloc/affordant_bloc.dart';

base mixin Auth on DependencyInjection {
  AuthService get auth => di.get();
}

final class SignInAnonymously extends Command with Auth {
  const SignInAnonymously();

  @override
  Future<void> run() async {
    await auth.signInAnonymously();
  }
}

final class SignInWithEmailAndPassword extends Command with Auth {
  const SignInWithEmailAndPassword(this.email, this.password);

  final String email;
  final String password;

  @override
  Future<void> run() async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }
}

final class SignOut extends Command with Auth {
  const SignOut();

  @override
  Future<void> run() async {
    await auth.signOut();
  }
}

final class UserQuery extends Query<User?> with Observer, Auth {
  UserQuery() : super(null) {
    watch(auth.authStateChanges, emit);
  }
}
