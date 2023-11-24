import 'affordant_core_localizations.dart';

/// The translations for French (`fr`).
class AffordantCoreLocalizationsFr extends AffordantCoreLocalizations {
  AffordantCoreLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get error_server_unspecified_title => 'Une erreur est survenue sur notre serveur';

  @override
  String get error_server_unspecified_message => 'Une erreur est survenue sur notre serveur. Veuillez réessayer plus tard. Si le problème persiste, veuillez nous contacter.';

  @override
  String get error_network_unavailable_title => 'Appareil non connecté.';

  @override
  String get error_network_unavailable_message => 'Il semble que votre appareil ne soit pas connecté à Internet. Veuillez connecter votre appareil et réessayer';

  @override
  String get error_server_unavailable_title => 'Serveur indisponible.';

  @override
  String get error_server_unavailable_message => 'Le serveur est actuellement indisponible. Cela peut être dû à une maintenance de notre système. Veuillez réessayer plus tard. Si le problème persiste, veuillez nous contacter';
}
