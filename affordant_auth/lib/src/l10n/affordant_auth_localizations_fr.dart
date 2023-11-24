import 'affordant_auth_localizations.dart';

/// The translations for French (`fr`).
class AffordantAuthLocalizationsFr extends AffordantAuthLocalizations {
  AffordantAuthLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get error_registration_account_already_exists_title => 'Adresse email indisponible.';

  @override
  String get error_registration_account_already_exists_message => 'Un compte avec cette address email exist déjà. Essayez de vous connecter.';

  @override
  String get error_sign_in_invalid_credentials_title => 'Identifiants invalides.';

  @override
  String get error_sign_in_invalid_credentials_message => 'Les identifiants que vous avez fournis ne sont invalides.';
}
