import 'affordant_core_localizations.dart';

/// The translations for French (`fr`).
class AffordantCoreLocalizationsFr extends AffordantCoreLocalizations {
  AffordantCoreLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get error_server_unspecified_title => 'An error occurred on our server';

  @override
  String get error_server_unspecified_message => 'An error occurred on our server. Please try again later. If the problem persist please contact us.';

  @override
  String get error_network_unavailable_title => 'Device not connected.';

  @override
  String get error_network_unavailable_message => 'Its seams that your devices isn\'t connect to internet. Please connect your device and try again';

  @override
  String get error_server_unavailable_title => 'Server unavailable.';

  @override
  String get error_server_unavailable_message => 'Server is actually unavailable. This may be due to a maintenance. Please try again later. If the problem persist please contact us';
}
