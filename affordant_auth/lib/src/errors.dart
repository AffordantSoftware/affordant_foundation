part of 'auth_repository.dart';

// Registration
sealed class RegistrationError extends Error {
  RegistrationError([super.error, super.stackTrace, super.context]);
}

final class AccountAlreadyExistsError extends RegistrationError {
  AccountAlreadyExistsError([super.error, super.stackTrace, super.context]);
}

final class UnknownRegistrationError extends RegistrationError {
  UnknownRegistrationError([super.error, super.stackTrace, super.context]);
}

// Sign in
sealed class SignInError extends Error {
  SignInError([super.error, super.stackTrace, super.context]);
}

final class InvalidCredentialError extends SignInError {
  InvalidCredentialError([super.error, super.stackTrace, super.context]);
}

final class GoogleSignInError extends SignInError {
  GoogleSignInError([super.error, super.stackTrace, super.context]);
}

final class AppleSignInError extends SignInError {
  AppleSignInError([super.error, super.stackTrace, super.context]);
}

final class AnonymousSignInError extends SignInError {
  AnonymousSignInError(super.error);
}

final class FacebookSignInError extends SignInError {
  FacebookSignInError([super.error, super.stackTrace, super.context]);
}

final class UnknownSignInError extends SignInError {
  UnknownSignInError([super.error, super.stackTrace, super.context]);
}

// Sign out
final class SignOutError extends Error {
  SignOutError([super.error, super.stackTrace, super.context]);
}

// Reset password
final class ResetPasswordError extends Error {
  ResetPasswordError([super.error, super.stackTrace, super.context]);
}

final class ReAuthenticateError extends SignInError {
  ReAuthenticateError([super.error, super.stackTrace, super.context]);
}

final class DeleteAccountError extends Error {
  DeleteAccountError([super.error, super.stackTrace, super.context]);
}
