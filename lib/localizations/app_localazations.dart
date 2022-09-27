import 'dart:async';

import 'package:base_bloc/localizations/app_localization_en.dart';
import 'package:base_bloc/localizations/app_localization_pl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Heroes of Computer Science'**
  String get appTitle;

  String get home;

  String get routes;

  String get climb;

  String get reservations;

  String get profile;

  String get appName;

  String get nextClimb;

  String get playlist;

  String get history;

  String get favourite;

  String get designed;

  String get route;

  String get sort;

  String get filter;

  String get moveToPlaylist;

  String get addToPlaylist;

  String get addToFavourite;

  String get removeFromPlaylist;

  String get removeFromFavorite;

  String get share;

  String get copy;

  String get edit;

  String get delete;

  String get select;

  String get removeFilter;

  String get author;

  String get status;

  String get corners;

  String get withCorner;

  String get withoutCorners;

  String get authorGrade;

  String get notTried;

  String get ufUnfinished;

  String get suSupported;

  String get trTopRope;

  String get rpRedPoint;

  String get osOnSight;

  String get authorsGrade;

  String get userGrade;

  String get designedBy;

  String get routeSetter;

  String get friends;

  String get showResult;

  String get notItemSelect;

  String get user;
  String get popularity;
  String get info;
  String get today;
  String get nextWeek;
  String get tomorrow;

  /* Profiles */
  String get tabPosts;
  String get tabHistory;
  String get tabDesigned;
  String get countPassed;
  String get countDesigned;
  String get countFriends;
  String get editSettings;

  String get settings;
  String get settingsAccount;
  String get settingsNotifications;
  String get settingsPrivacy;
  String get settingsGeneral;
  String get cancelYourReservation;

  String get account_change_photo;
  String get account_nickname;
  String get account_name;
  String get account_surname;
  String get account_type;
  String get account_height;
  String get account_favorite_route_grade;
  String get account_email;


  String get hinTextSearchHome;

  String get all;

  String get places;

  String get persons;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationEn();
    case 'pl':
      return AppLocalizationEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
