import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'affordant_auth_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AffordantAuthLocalizations
/// returned by `AffordantAuthLocalizations.of(context)`.
///
/// Applications need to include `AffordantAuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/affordant_auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AffordantAuthLocalizations.localizationsDelegates,
///   supportedLocales: AffordantAuthLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AffordantAuthLocalizations.supportedLocales
/// property.
abstract class AffordantAuthLocalizations {
  AffordantAuthLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AffordantAuthLocalizations of(BuildContext context) {
    return Localizations.of<AffordantAuthLocalizations>(context, AffordantAuthLocalizations)!;
  }

  static const LocalizationsDelegate<AffordantAuthLocalizations> delegate = _AffordantAuthLocalizationsDelegate();

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
    Locale('en')
  ];

  /// No description provided for @error_registration_account_already_exists_title.
  ///
  /// In en, this message translates to:
  /// **'Account already exists.'**
  String get error_registration_account_already_exists_title;

  /// No description provided for @error_registration_account_already_exists_message.
  ///
  /// In en, this message translates to:
  /// **'It seams that an account already uses this email address. Please try to connect or use a different email address.'**
  String get error_registration_account_already_exists_message;

  /// No description provided for @error_sign_in_invalid_credentials_title.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get error_sign_in_invalid_credentials_title;

  /// No description provided for @error_sign_in_invalid_credentials_message.
  ///
  /// In en, this message translates to:
  /// **'The password entered doesn\'t match the credential. Please try another password or use a different email address. If the problem persist, please try to reset the password.'**
  String get error_sign_in_invalid_credentials_message;
}

class _AffordantAuthLocalizationsDelegate extends LocalizationsDelegate<AffordantAuthLocalizations> {
  const _AffordantAuthLocalizationsDelegate();

  @override
  Future<AffordantAuthLocalizations> load(Locale locale) {
    return SynchronousFuture<AffordantAuthLocalizations>(lookupAffordantAuthLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AffordantAuthLocalizationsDelegate old) => false;
}

AffordantAuthLocalizations lookupAffordantAuthLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AffordantAuthLocalizationsEn();
  }

  throw FlutterError(
    'AffordantAuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
