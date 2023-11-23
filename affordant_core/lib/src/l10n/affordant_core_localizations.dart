import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'affordant_core_localizations_en.dart';
import 'affordant_core_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AffordantCoreLocalizations
/// returned by `AffordantCoreLocalizations.of(context)`.
///
/// Applications need to include `AffordantCoreLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/affordant_core_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AffordantCoreLocalizations.localizationsDelegates,
///   supportedLocales: AffordantCoreLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AffordantCoreLocalizations.supportedLocales
/// property.
abstract class AffordantCoreLocalizations {
  AffordantCoreLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AffordantCoreLocalizations of(BuildContext context) {
    return Localizations.of<AffordantCoreLocalizations>(context, AffordantCoreLocalizations)!;
  }

  static const LocalizationsDelegate<AffordantCoreLocalizations> delegate = _AffordantCoreLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @error_server_unspecified_title.
  ///
  /// In en, this message translates to:
  /// **'An error occurred on our server'**
  String get error_server_unspecified_title;

  /// No description provided for @error_server_unspecified_message.
  ///
  /// In en, this message translates to:
  /// **'An error occurred on our server. Please try again later. If the problem persist, contact (Customer Care)[]'**
  String get error_server_unspecified_message;

  /// No description provided for @error_network_unavailable_title.
  ///
  /// In en, this message translates to:
  /// **'Device not connected.'**
  String get error_network_unavailable_title;

  /// No description provided for @error_network_unavailable_message.
  ///
  /// In en, this message translates to:
  /// **'Its seams that your devices isn\'t connect to internet. Please connect your device and try again'**
  String get error_network_unavailable_message;

  /// No description provided for @error_server_unavailable_title.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable.'**
  String get error_server_unavailable_title;

  /// No description provided for @error_server_unavailable_message.
  ///
  /// In en, this message translates to:
  /// **'Server is actually unavailable. This may be due to a maintenance. Please try again later. If the problem persist, contact (Customer Care)[]'**
  String get error_server_unavailable_message;
}

class _AffordantCoreLocalizationsDelegate extends LocalizationsDelegate<AffordantCoreLocalizations> {
  const _AffordantCoreLocalizationsDelegate();

  @override
  Future<AffordantCoreLocalizations> load(Locale locale) {
    return SynchronousFuture<AffordantCoreLocalizations>(lookupAffordantCoreLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AffordantCoreLocalizationsDelegate old) => false;
}

AffordantCoreLocalizations lookupAffordantCoreLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AffordantCoreLocalizationsEn();
    case 'fr': return AffordantCoreLocalizationsFr();
  }

  throw FlutterError(
    'AffordantCoreLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
