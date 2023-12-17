part of 'auth_repository.dart';

extension _L10n on BuildContext {
  AffordantAuthLocalizations get l10n =>
      Localizations.of<AffordantAuthLocalizations>(
          this, AffordantAuthLocalizations)!;
}

// Registration
sealed class RegistrationException with DisplayableError implements Exception {
  const RegistrationException();
}

final class AccountAlreadyExistsException extends RegistrationException {
  @override
  String localizedMessage(BuildContext context) =>
      context.l10n.error_registration_account_already_exists_message;

  @override
  String localizedTitle(BuildContext context) =>
      context.l10n.error_registration_account_already_exists_title;
}

// Sign in
sealed class SignInException with DisplayableError implements Exception {
  const SignInException();
}

final class InvalidCredentialException extends SignInException {
  const InvalidCredentialException();

  @override
  String localizedMessage(BuildContext context) =>
      context.l10n.error_sign_in_invalid_credentials_message;

  @override
  String localizedTitle(BuildContext context) =>
      context.l10n.error_sign_in_invalid_credentials_title;
}

final class SocialSignInException extends SignInException {
  const SocialSignInException(this.error);

  final Object error;

  @override
  String localizedMessage(BuildContext context) =>
      context.l10n.error_registration_account_already_exists_message;

  @override
  String localizedTitle(BuildContext context) =>
      context.l10n.error_registration_account_already_exists_title;
}
