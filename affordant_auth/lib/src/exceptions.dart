import 'package:affordant_auth/src/l10n/affordant_auth_localizations.dart';
import 'package:affordant_core/affordant_core.dart';
import 'package:flutter/widgets.dart';

extension _LocalizationDelegate on BuildContext {
  AffordantAuthLocalizations get _authL10n =>
      Localizations.of(this, AffordantAuthLocalizations);
}

sealed class RegistrationException with DisplayableException {
  const RegistrationException();
}

final class AccountAlreadyExistsException extends RegistrationException {
  @override
  String localizedTitle(BuildContext context) {
    return context._authL10n.error_registration_account_already_exists_title;
  }

  @override
  String localizedMessage(BuildContext context) {
    return context._authL10n.error_registration_account_already_exists_message;
  }
}

sealed class SignInException with DisplayableException {
  const SignInException();
}

final class InvalidCredentialException extends RegistrationException {
  @override
  String localizedTitle(BuildContext context) {
    return context._authL10n.error_sign_in_invalid_credentials_title;
  }

  @override
  String localizedMessage(BuildContext context) {
    return context._authL10n.error_sign_in_invalid_credentials_message;
  }
}
