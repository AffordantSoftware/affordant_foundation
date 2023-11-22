import 'affordant_auth_localizations.dart';

/// The translations for English (`en`).
class AffordantAuthLocalizationsEn extends AffordantAuthLocalizations {
  AffordantAuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get error_registration_account_already_exists_title => 'Account already exists.';

  @override
  String get error_registration_account_already_exists_message => 'It seams that an account already uses this email address. Please try to connect or use a different email address.';

  @override
  String get error_sign_in_invalid_credentials_title => 'Invalid credentials.';

  @override
  String get error_sign_in_invalid_credentials_message => 'The password entered doesn\'t match the credential. Please try another password or use a different email address. If the problem persist, please try to reset the password.';
}
