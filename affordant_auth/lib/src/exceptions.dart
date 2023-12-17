part of 'auth_repository.dart';

// Registration
sealed class RegistrationException implements Exception {
  const RegistrationException();
}

final class AccountAlreadyExistsException extends RegistrationException {}

// Sign in
sealed class SignInException implements Exception {
  const SignInException();
}

final class InvalidCredentialException extends SignInException {
  const InvalidCredentialException();
}

final class SocialSignInException extends SignInException {
  const SocialSignInException(this.error);

  final Object error;
}
